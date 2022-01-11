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
    
    var account: UserAccount? {
        homeModel.account
    }
    
    var studentInformation: Student? {
        homeModel.student
    }
    
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
                                print(error)
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
