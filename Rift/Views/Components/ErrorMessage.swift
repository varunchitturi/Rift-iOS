//
//  ErrorMessage.swift
//  Rift
//
//  Created by Varun Chitturi on 12/11/21.
//

import SwiftUI

struct ErrorMessage: View {
    
    init(error: Error, retryAction: ((Error) -> ())? = nil) {
        self.error = error
        self.retryAction = retryAction
    }
    
    
    let message: String = "An Error Occured"
    let error: Error
    let retryAction: ((Error) -> ())?
    
    var body: some View {
        VStack {
            Text(message)
                .font(.callout)
            if retryAction != nil {
                Button {
                    retryAction!(error)
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
struct ErrorMessage_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessage(error: URLError.notConnectedToInternet as! Error) { _ in
            
        }
    }
}
#endif
