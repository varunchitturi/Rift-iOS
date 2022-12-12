//
//  HomeViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/21/21.
//

import Firebase
import Foundation
import SwiftUI

/// MVVM view model for the `HomeView`
class HomeViewModel: ObservableObject {
    
    /// MVVM model
    @Published private var homeModel = HomeModel()
    
    /// Boolean that gives whether the `UserPreferenceView` is presented
    @Published var settingsIsPresented: Bool = false
    
    /// `AsyncState` to manage network calls in views
    @Published var networkState: AsyncState = .idle
    
    init() {
        fetchUser()
    }
    
    /// The account of the user
    var account: UserAccount? {
        homeModel.account
    }
    
    /// Student Information of the user
    var studentInformation: Student? {
        homeModel.student
    }
    
    /// Fetches user properties and configuration from the API
    func fetchUser() {
        API.Resources.getUserAccount { [weak self] result in
            switch result {
            case .success(let account):
                if let self = self {
                    API.Resources.getStudents { result in
                        switch result {
                        case .success(let students):
                            if let student = students.first(where: {$0.id == account.personID}) {
                                FirebaseApp.setUser(account: account, student: student)
                                DispatchQueue.main.async {
                                    self.homeModel.student = student
                                    self.networkState = .success
                                }
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.networkState = .failure(error)
                            }
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self?.networkState = .failure(URLError.init(.cancelled))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.networkState = .failure(error)
                }
            }
        }
    }
}
