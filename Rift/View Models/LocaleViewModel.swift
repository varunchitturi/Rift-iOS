//
//  LocaleViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation
import SwiftUI


class LocaleViewModel: ObservableObject {
    
    @Published var stateSelectionIndex: Int? {
        willSet {
            if stateSelectionIndex != newValue {
                chosenLocale = nil
            }
        }
    }
    @Published var searchResults = [Locale]()
    @Published var chosenLocale: Locale?
    
    var stateSelection: Locale.USTerritory? {
        stateSelectionIndex != nil ? Locale.USTerritory.allCases.sorted()[stateSelectionIndex!] : nil
    }
    
    // MARK: - Intents
    
    func searchDistrict(for query: String) {
        if let stateSelection = stateSelection {
            DispatchQueue.main.async {
                Locale.searchDistrict(for: query, state: stateSelection) {[weak self] result in
                    switch result {
                    case .success(let locales):
                        self?.searchResults = locales
                    case .failure(let error):
                        // TODO: better error handling here
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func resetQueries() {
        searchResults = []
        chosenLocale = nil
        stateSelectionIndex = nil
    }
    
    
    
}
