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
        fetchUser()
    }
    
    var user: UserAccount? {
        homeModel.user
    }
    
    func fetchUser() {
        API.Resources.getUserAccount { [weak self] result in
            switch result {
            case .success(let user):
                FirebaseApp.setUser(user)
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
