//
//  HomeViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/21/21.
//

import Firebase
import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published private var homeModel = HomeModel()
    @Published var settingsIsPresented: Bool = false
    @Published var networkState: AsyncState = .idle
    
    init() {
        if let locale = PersistentLocale.getLocale() {
            Analytics.setDefaultEventParameters(try? locale.allProperties())
        }
        fetchUser()
    }
    
    func fetchUser() {
        API.Resources.getUserAccount { [weak self] result in
            switch result {
            case .success(let user):
                Analytics.setUserProperties(user)
                Crashlytics.crashlytics().setUserID(user.id)
                DispatchQueue.main.async {
                    self?.networkState = .success
                    self?.homeModel.user = user
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.networkState = .failure(error)
                }
            }
        }
    }
}
