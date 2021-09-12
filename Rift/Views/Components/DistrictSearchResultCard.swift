//
//  DistrictSearchResultCard.swift
//  DistrictSearchResultCard
//
//  Created by Varun Chitturi on 9/7/21.
//

import SwiftUI

struct DistrictSearchResultCard: View {
    
    init(for result: Locale) {
        self.result = result
    }
    
    var result: Locale
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(result.districtName)
                    .lineLimit(DrawingConstants.textLineLimit)
                Spacer(minLength: DrawingConstants.minimumTextTrailingSpace)
                Image(systemName: "arrow.up.left")
            }
            .foregroundColor(DrawingConstants.foregroundColor)
        }.padding(.vertical)
    }
    
    private struct DrawingConstants {
        static let minimumTextTrailingSpace: CGFloat = 25
        static let textLineLimit = 1
        static let foregroundColor = Color("Tertiary")
    }
}

struct DistrictSearchResultCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ForEach(0..<5) {_ in
                DistrictSearchResultCard(for: Locale(id: 1, districtName: "Fremont Unified School District", districtAppName: "FUSD", districtBaseURL: URL(string: "https://")!, districtCode: "fusd", state: .CA, staffLoginURL: URL(string: "https://")!, studentLoginURL: URL(string: "https://")!, parentLoginURL: URL(string: "https://")!))
                Divider()
            }
            .padding()
            .padding(.horizontal)
        }
    }
}
