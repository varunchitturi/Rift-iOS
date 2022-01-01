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
        }
        
        // TODO: make these functions more modular. To create a new API request function, I shouldn't be copy pasting from a previous API. Maybe create an API Request struct for get request in the API struct?
        
        static func getUserAccount(locale: Locale? = nil, completion: @escaping (Result<UserAccount, Error>) -> ()) {
            guard let locale = locale ?? PersistentLocale.getLocale() else { return }
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Resources.Endpoint.userAccount))
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = (error ?? APIError(response: response)) {
                    completion(.failure(error))
                }
                else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let responseBody = try decoder.decode(UserAccount.self, from: data)
                        completion(.success(responseBody))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
                else {
                    completion(.failure(APIError.invalidData))
                }
            }.resume()
        }
    }
}
