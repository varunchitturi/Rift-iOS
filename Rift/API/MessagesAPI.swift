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
            
            API.defaultRequestManager.get(url: url) { result in
                switch result {
                case .success((let data, _)):
                    do {
                        guard let messageHTML = String(data: data, encoding: .ascii) else {
                            throw APIError.invalidData
                        }
                        let doc = try SwiftSoup.parse(messageHTML)
                        completion(.success(try doc.text()))
                    }
                    catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
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
