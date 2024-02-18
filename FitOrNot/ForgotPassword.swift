//
//  ForgotPassword.swift
//  FitOrNot
//
//  Created by Sartaj Gill  on 10/29/23.
//

import SwiftUI
import FirebaseAuth

struct ForgotPassword: View {
    @State private var email = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text("Reset Password")
                    .font(Font.custom("Koulen", size: 32))
                    .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                    .offset(x: 20, y: -200)
                HStack{
                    Text("Return to Login?")
                        .font(Font.custom("Koulen", size: 16))
                        .foregroundColor(.black)
                    NavigationLink(destination: LogIn()
                        .navigationBarBackButtonHidden()){
                            Text("Login")
                                .font(Font.custom("Koulen", size: 16))
                                .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                        }
                }
                .offset(x: 20, y: -200)
                VStack(spacing:24){
                    InputView(text: $email, title: "Email Address", placeholder: "email@example.com")
                        .autocapitalization(.none).padding(.horizontal)
                    
                    Button {
                        sendPasswordReset()
                    } label: {
                        HStack {
                            Text("Reset Password")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(minWidth: 244, maxWidth: .infinity, maxHeight: 70, alignment: .center)
                        .background(Color(.systemBlue))
                        .font(Font.custom("Koulen", size: 30))
                        .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                        .background(Color(red: 0.89, green: 0.89, blue: 0.89))
                        .cornerRadius(50)
                        .padding(.horizontal)
                        .padding(.top, 24)
                    }
                    
                }
            }
            
        }
    }
    func sendPasswordReset() {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print("Password reset failed: \(error.localizedDescription)")
                } else {
                    print("Password reset email sent successfully")
                }
            }
        }
}



#Preview {
    ForgotPassword()
}
