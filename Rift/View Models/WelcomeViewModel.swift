//
//  WelcomeViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation
import SwiftUI


/// MVVM view model for the `WelcomeView`
class WelcomeViewModel: ObservableObject {
    
    /// MVVM model
    @Published private var welcome = WelcomeModel()
    
    /// The index of selected state
    @Published var stateSelectionIndex: Int? {
        willSet {
            if stateSelectionIndex != newValue {
                welcome.chosenLocale = nil
            }
        }
    }
    
    /// The selected state based on the the `stateSelectionIndex`
    private var stateSelection: Locale.USTerritory? {
        stateSelectionIndex != nil ? Locale.USTerritory.allCases.sorted()[stateSelectionIndex!] : nil
    }
    
    /// Gives whether the user selected a locale and can proceed to the log in page
    var navigationIsDisabled: Bool {
        welcome.chosenLocale == nil
    }
    
    /// The district search results based on a query to the API
    var districtSearchResults: [Locale] {
        get {
            welcome.districtSearchResults
        }
        set {
            welcome.districtSearchResults = newValue
        }
    }
    
    /// The locale that the user chose
    var chosenLocale: Locale? {
        get {
            welcome.chosenLocale
        }
        set {
            welcome.chosenLocale = newValue
        }
    }
    
    // MARK: - Intents
    
    /// Searches for possible locales based on a query and a chosen state
    /// - Parameter query: The query to use to search
    /// - `query`
    func searchDistrict(for query: String) {
        if let stateSelection = stateSelection {
            API.DistrictSearch.searchDistrict(for: query, state: stateSelection) {[weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let locales):
                        self?.welcome.districtSearchResults = locales
                    case .failure(_):
                        // TODO: better error handling here
                        self?.welcome.districtSearchResults = []
                    }
                }
            }
        }
    }
    
    /// Resets any user selections
    func resetInput() {
        stateSelectionIndex = nil
        welcome.resetQueries()
    }
}
