//
//  LocaleViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation
import SwiftUI

class LocaleViewModel: ObservableObject {
    
    @Published var stateSelectionIndex: Int?
    @Published var searchResults = [Locale]()
    @Published var chosenLocale: Locale?
    
    var stateSelection: Locale.USTerritory? {
        stateSelectionIndex != nil ? Locale.USTerritory.allCases.sorted()[stateSelectionIndex!] : nil
    }
    
    // MARK: - Intents
    
    func searchDistrict(for query: String) {
        if let stateSelection = stateSelection {
            Locale.searchDistrict(for: query, state: stateSelection) {[weak self] result in
                switch result {
                case .success(let locales):
                    self?.searchResults = locales
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
}
