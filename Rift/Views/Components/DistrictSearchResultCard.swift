//
//  DistrictSearchResultCard.swift
//  DistrictSearchResultCard
//
//  Created by Varun Chitturi on 9/7/21.
//

import SwiftUI

struct DistrictSearchResultCard: View {
    var result: Locale
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(result.districtName)
                    .lineLimit(DrawingConstants.textLineLimit)
                Spacer(minLength: DrawingConstants.minimumTextTrailingSpace)
                Image(systemName: "arrow.up.left")
            }
            .foregroundColor(Color("Tertiary"))
        }.padding(.vertical)
    }
    
    private struct DrawingConstants {
        static let minimumTextTrailingSpace: CGFloat = 25
        static let textLineLimit = 1
    }
}

struct DistrictSearchResultCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ForEach(0..<5) {_ in
                DistrictSearchResultCard(result: Locale(id: 1, districtName: "Fremont Unified School District", districtAppName: "FUSD", districtBaseURL: URL(string: "https://")!, districtCode: "fusd", state: .CA, staffLoginURL: URL(string: "https://")!, userLoginURL: URL(string: "https://")!))
                Divider()
            }
            .padding()
            .padding(.horizontal)
        }
    }
}
