//
//  SplashScreen.swift
//  Rift
//
//  Created by Varun Chitturi on 12/7/21.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack(alignment: .center) {
            Icon()
                .frame(width: DrawingConstants.loaderWidth)
        }
    }

    private struct DrawingConstants {
        static let loaderWidth: CGFloat = UIScreen.main.bounds.size.width * 0.4
    }
}

#if DEBUG
struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
#endif
