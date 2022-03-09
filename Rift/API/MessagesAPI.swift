//
//  MessagesAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation
import SwiftSoup
import URLEncodedForm

extension API {
    
    /// API to get messages for a user
    struct Messages {
        
        /// Collection of endpoints for messages
        enum Endpoint {
            /// Endpoint to get all messages for a user
            static let messageList = "api/portal/process-message/"
            /// Endpoint to delete a message
            static let deleteMessage = "execute/"
        }
        
        /// Gets all messages for a user
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - completion: Completion function
        static func getMessageList(locale: Locale? = nil, completion: @escaping (Result<[Message], Error>) -> Void) {
            API.defaultRequestManager.get(endpoint: Endpoint.messageList, locale: locale) { result in
                switch result {
                case .success((let data, _)):
                    do {
                        let decoder = JSONDecoder()
                        let messages = try decoder.decode([Message].self, from: data)
                        completion(.success(messages))
                    }
                    catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        /// Gets a body for a `Message`
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - message: The message to get a body for
        ///   - completion: Completion function
        static func getMessageBody(locale: Locale? = nil, message: Message, completion: @escaping (Result<String, Error>) -> Void) {
            guard let locale = locale ?? PersistentLocale.getLocale() else {
                completion(.failure(API.APIError.invalidLocale))
                return
            }
        
            let endpoint = message.endpoint
            
            
            guard let url = URL(
                string: locale.districtBaseURL.appendingPathComponent(endpoint).description.removingPercentEncoding ?? ""
            ) else {
                return completion(.failure(APIError.invalidRequest))
            }
            
            API.defaultRequestManager.get(url: url) { result in
                switch result {
                case .success((let data, let response)):
                    if let requestURL = url.removingQueries(),
                        let responseURL = response.url?.removingQueries(),
                        requestURL == responseURL {
                        do {
                            guard let messageHTML = String(data: data, encoding: .ascii) else {
                                throw APIError.invalidData
                            }
                            let doc = try SwiftSoup.parse(messageHTML)
                            
                            for anchor in try doc.getElementsByTag("a") {
                                // Converts links in html to links in markdown. Allows for easy embedding of links.
                                try anchor.html("[\(try anchor.text())](\(try anchor.attr("href")))")
                            }
                            
                            let elements = try doc.getElementsByTag("p")
                            var body = ""
                            for (index, element) in elements.enumerated() {
                                body += "\(try element.text())"
                                if index != elements.endIndex-1 {
                                    body += "\n"
                                }
                            }
                            completion(.success(body))
                        }
                        catch {
                            completion(.failure(error))
                        }
                    }
                    else {
                        completion(.failure(APIError.responseError(response.status)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        /// Deletes a given message
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - message: Message to delete
        ///   - completion: Completion function
        static func deleteMessage(locale: Locale? = nil, message: Message, completion: @escaping (Error?) -> Void) {
            API.defaultRequestManager.post(endpoint: Endpoint.deleteMessage, data: DeleteMessageBodyRequest(processMessageID: message.id), encodeType: .form, locale: locale) { result in
                switch result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
                
            }
        }
        
        /// A type that is encoded in order to make a network request to delete a message
        private struct DeleteMessageBodyRequest: Encodable {
            let request = "messenger.MessengerEngine-deleteMessageRecipientView"
            let processMessageID: Int
            
            enum CodingKeys: String, CodingKey {
                case request = "x"
                case processMessageID
            }
        }
        
    }
}
