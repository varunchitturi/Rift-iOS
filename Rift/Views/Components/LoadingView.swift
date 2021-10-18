//
//  LoadingView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/2/21.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack(alignment: .center) {
            ProgressView()
        }
    }
}

#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
#endif
