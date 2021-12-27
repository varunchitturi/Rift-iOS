//
//  ErrorMessage.swift
//  Rift
//
//  Created by Varun Chitturi on 12/11/21.
//

import SwiftUI

struct ErrorDisplay: View {
    
    init(message: String? = nil, error: Error? = nil, retryAction: ((Error) -> ())? = nil) {
        self.message = message ?? "An Error Occured"
        self.error = error
        self.retryAction = retryAction
    }
    
    let message: String
    let error: Error?
    let retryAction: ((Error) -> ())?
    
    var body: some View {
        VStack {
            HStack {
                Text(message)
                    .font(.callout)
                    .multilineTextAlignment(.center)
            }
           
            if retryAction != nil, error != nil {
                Button {
                    retryAction!(error!)
                } label: {
                    Text("Try Again")
                        .font(.footnote)
                        .padding(.vertical, DrawingConstants.retryTextVerticalPadding)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: DrawingConstants.retryButtonCornerRadius)
                                .stroke()
                        )
                }
            }
        }
        .foregroundColor(Rift.DrawingConstants.foregroundColor)
    }
    
    private struct DrawingConstants {
        static let retryButtonCornerRadius: CGFloat = 2
        static let retryTextVerticalPadding: CGFloat = 5
    }
}

#if DEBUG
struct ErrorDisplay_Previews: PreviewProvider {
    static var previews: some View {
        
        ErrorDisplay(message: """
                     An authentication error occured
                     Please logout and log back in
                     """, error: URLError.init(.notConnectedToInternet))
            .padding()
    }
}
#endif
