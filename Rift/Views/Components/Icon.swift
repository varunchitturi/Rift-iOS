//
//  Icon.swift
//  Rift
//
//  Created by Varun Chitturi on 12/7/21.
//

import SwiftUI

struct Icon: View {
    var body: some View {
        Image("Icon")
            .resizable()
            .scaledToFit()
    }
}

#if DEBUG
struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon()
    }
}
#endif
