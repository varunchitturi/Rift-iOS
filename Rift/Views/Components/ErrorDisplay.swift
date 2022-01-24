//
//  ErrorMessage.swift
//  Rift
//
//  Created by Varun Chitturi on 12/11/21.
//

import SwiftUI

struct ErrorDisplay: View {
    
    init(_ message: String? = nil, error: Error, retryAction: ((Error) -> ())? = nil) {
        self.message = message ?? "An Error Occured"
        self.retryAction = retryAction
        self.error = error
        self.retryMessage = nil
    }
    init(_ message: String? = nil, error: Error, retryMessage: String, retryAction: @escaping ((Error) -> ())) {
        self.message = message ?? "An Error Occured"
        self.retryMessage = retryMessage
        self.retryAction = retryAction
        self.error = error
    }
    
    let error: Error
    let message: String
    let retryMessage: String?
    let retryAction: ((Error) -> ())?
    
    var body: some View {
        VStack {
            HStack {
                Text(message)
                    .font(.callout)
                    .multilineTextAlignment(.center)
            }
           
            if retryAction != nil {
                Button {
                    retryAction!(error)
                } label: {
                    Text(retryMessage ?? "Try Again")
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
    
    private enum DrawingConstants {
        static let retryButtonCornerRadius: CGFloat = 2
        static let retryTextVerticalPadding: CGFloat = 5
    }
}

#if DEBUG
struct ErrorDisplay_Previews: PreviewProvider {
    static var previews: some View {
        
        ErrorDisplay("""
                     An authentication error occured
                     Please logout and log back in
                     """, error: URLError.init(.notConnectedToInternet))
            .padding()
    }
}
#endif
