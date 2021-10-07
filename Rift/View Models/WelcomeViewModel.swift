//
//  WelcomeViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation
import SwiftUI


class WelcomeViewModel: ObservableObject {
    
    @Published private var welcome = WelcomeModel()
    
    @Published var stateSelectionIndex: Int? {
        willSet {
            if stateSelectionIndex != newValue {
                welcome.chosenLocale = nil
            }
        }
    }
    
    var stateSelection: Locale.USTerritory? {
        stateSelectionIndex != nil ? Locale.USTerritory.allCases.sorted()[stateSelectionIndex!] : nil
    }
    
    var navigationIsDisabled: Bool {
        welcome.chosenLocale == nil
    }
    
    var districtSearchResults: [Locale] {
        get {
            welcome.districtSearchResults
        }
        set {
            welcome.districtSearchResults = newValue
        }
    }
    
    var chosenLocale: Locale? {
        get {
            welcome.chosenLocale
        }
        set {
            welcome.chosenLocale = newValue
        }
    }
    
    // MARK: - Intents
    
    func searchDistrict(for query: String) {
        if let stateSelection = stateSelection {
            API.DistrictSearch.searchDistrict(for: query, state: stateSelection) {[weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let locales):
                        self?.welcome.districtSearchResults = locales
                    case .failure(let error):
                        // TODO: better error handling here
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func reset() {
        stateSelectionIndex = nil
        welcome.resetQueries()
        
    }
}
