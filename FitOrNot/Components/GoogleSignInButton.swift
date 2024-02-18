//
//  GoogleSignInButton.swift
//  FitOrNot
//
//  Created by Sartaj Gill  on 10/7/23.
//

import SwiftUI

struct GoogleSiginBtn: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                
                Image("Google")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .mask(
                        Circle()
                    )
            }
            
        }
        .frame(width: 50, height: 50)
    }
}

struct GoogleSiginBtn_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSiginBtn(action: {})
    }
}
