//
//  ResourcesAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Foundation

extension API {
    /// API for to get user and school information
    struct Resources {
        
        /// Collection of endpoints to get user and school information
        private enum Endpoint {
            /// Endpoint to get a user's account
            static let userAccount = "resources/my/userAccount/"
            /// Endpoint to get a student's information
            static let students = "api/portal/students"
        }
        
        /// Gets a user account
        /// - Parameters:
        ///   - locale: <#locale description#>
        ///   - completion: <#completion description#>
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
        
        /// Gets student information
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - completion: Completion function
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
