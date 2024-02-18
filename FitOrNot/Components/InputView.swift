//
//  InputView.swift
//  FitOrNot
//
//  Created by Sartaj Gill  on 9/27/23.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecuredField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecuredField{
                SecureField(placeholder, text: $text)
                    .font(.system(size:16))
            } else{
                TextField(placeholder, text: $text)
                    .font(.system(size:16))            }
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "email@example.com")
}
