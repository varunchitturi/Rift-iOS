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
    
    struct Messages {
        
        enum Endpoint {
            static let messageList = "api/portal/process-message/"
            static let deleteMessage = "execute/"
        }
        
        static func getMessageList(locale: Locale? = nil, completion: @escaping (Result<[Message], Error>) -> Void) {
            guard let locale = locale ?? PersistentLocale.getLocale() else {
                completion(.failure(API.APIError.invalidLocale))
                return
            }
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.messageList))
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let messages = try decoder.decode([Message].self, from: data)
                        completion(.success(messages))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
                else {
                    completion(.success([]))
                }
            }.resume()
            
        }
        
        static func getMessageBody(locale: Locale? = nil, message: Message, completion: @escaping (Result<String, Error>) -> Void) {
            guard let locale = locale ?? PersistentLocale.getLocale() else {
                completion(.failure(API.APIError.invalidLocale))
                return
            }
            
            let endpoint = message.endpoint
            
            
            guard let url = URL(
                string: locale.districtBaseURL.appendingPathComponent(endpoint).description.removingPercentEncoding ?? ""
            ) else {
                completion(.failure(APIError.invalidRequest))
                return
            }
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let messageHTML = try String(contentsOf: url)
                    let doc = try SwiftSoup.parse(messageHTML)
                    completion(.success(try doc.text()))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        static func deleteMessage(locale: Locale? = nil, message: Message, completion: @escaping (Error?) -> Void) {
            guard let locale = locale ?? PersistentLocale.getLocale() else {
                completion(API.APIError.invalidLocale)
                return
            }
            
            var urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.deleteMessage))
            // TODO: convert these network enum from cases to static let in order to avoid raw value
            urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
            urlRequest.setValue(URLRequest.ContentType.form.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
            
            let formEncoder = URLEncodedFormEncoder()
            
            do {
                urlRequest.httpBody = try formEncoder.encode(DeleteMessageBody(processMessageID: message.id))
                API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        completion(error)
                    }
                    else {
                        completion(nil)
                    }
                }
            }
            catch {
                completion(error)
            }
        }
        
        private struct DeleteMessageBody: Encodable {
            let x = "messenger.MessengerEngine-deleteMessageRecipientView"
            let processMessageID: Int
        }
        
    }
}
