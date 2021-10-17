//
//  MessagesAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation

extension API {
    
    struct Messages {
        
        enum Endpoint {
            static let messageList = "api/portal/process-message"
        }
        
        static func getMessages(locale: Locale? = nil, completion: @escaping (Result<[GradeTerm], Error>) -> Void) {
            guard let locale = locale ?? PersistentLocale.getLocale() else {
                completion(.failure(APIError.invalidLocale))
                return
            }
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.messageList))
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    struct Response: Codable {
                        // TODO: use custom term here
                        let gradeTerms: [GradeTerm]
                        
                        enum CodingKeys: String, CodingKey {
                            case gradeTerms = "terms"
                        }
                   }
                    do {
                        let decoder = JSONDecoder()
                        let responseBody = try decoder.decode([Response].self, from: data)
                        !responseBody.isEmpty ? completion(.success(responseBody[0].gradeTerms)) : completion(.failure(APIError.invalidData))
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
    }
}
