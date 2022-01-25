//
//  ResourcesAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Foundation

extension API {
    struct Resources {
        
        private enum Endpoint {
            static let userAccount = "resources/my/userAccount/"
            static let students = "api/portal/students"
        }

        static func getUserAccount(locale: Locale? = nil, completion: @escaping (Result<UserAccount, Error>) -> ()) {
    
            API.defaultRequestManager.get(endpoint: Endpoint.userAccount, locale: locale) { result in
                switch result {
                case .success((let data, _)):
                    do {
                        let decoder = JSONDecoder()
                        let responseBody = try decoder.decode(UserAccount.self, from: data)
                        completion(.success(responseBody))
                    }
                    catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        static func getStudents(locale: Locale? = nil, completion: @escaping (Result<[Student], Error>) -> ()) {
            
            API.defaultRequestManager.get(endpoint: Endpoint.students, locale: locale) { result in
                switch result {
                case .success((let data, _)):
                    do {
                        let decoder = JSONDecoder()
                        let responseBody = try decoder.decode([Student].self, from: data)
                        completion(.success(responseBody))
                    }
                    catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
