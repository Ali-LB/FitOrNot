//
//  LogIn.swift
//  FitOrNot
//
//  Created by Ali Farhat on 9/20/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LogIn: View {
    @State private var email = ""
    @State private var password = ""
    
    // isTermsOfUse and isPrivacyPolicy was created to toggle activating the sheet to display the file on screen Lines 17 - 18 - AF
    @State private var isTermsOfUse = false
    @State private var isPrivacyPolicy = false
    
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    // inFocus was created to toggle between the hidden password and show password fields as well as showPassword to toggle between them Lines 24 - 25 - AF
    @FocusState var inFocus: Field?
    @State private var showPassword: Bool = false
    
    // The fields used for inFocus to toggle the textfield is either secure or plain for displaying the password to the user 28 - 30 - AF
    enum Field {
        case secure, plain
    }
    
    var body: some View {
        // Lines 34 - 59 Ali Farhat
        VStack{
            // VStack is aligned as leading - AF
            VStack(alignment: .leading){
                // Text displaying Log In header - AF
                Text("LOG IN")
                    // Text Properties (Custom font/size, color set, and offset) - AF
                    .font(Font.custom("Koulen", size: 32))
                    .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                    .offset(x: 20, y: -30)
                // Underneath the header there is a subheader linking to the login page with a subline - AF
                HStack{
                    // Text displaying New to FitOrNot? - AF
                    Text("New to FitOrNot?")
                        // Text Properties (Custom font/size, color set to black) - AF
                        .font(Font.custom("Koulen", size: 16))
                        .foregroundColor(.black)
                    // Navigation link for the text Sign Up if interacted takes user to the Sign Up View with the back button hidden - AF
                    NavigationLink(destination: SignUp()
                        .navigationBarBackButtonHidden()){
                            Text("Sign Up")
                                // Text Properties (Custom font/size, color set) - AF
                                .font(Font.custom("Koulen", size: 16))
                                .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                        }
                }
                .offset(x: 20, y: -30)
                VStack(spacing:24){
                    InputView(text: $email, title: "Email Address", placeholder: "email@example.com")
                        .autocapitalization(.none).padding(.horizontal)
                    
                    // Lines 65 - 106 Ali Farhat
                    // Text displaying Password field - AF
                    Text("Password")
                        // Text Properties (Color set to dark gray, semi bold, font, and offset) - AF
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                        .offset(x:-170, y:10)
                    // IF statement checking if the var showPassword is true or false, if true shows the password users are typing else false hides the password - AF
                    if showPassword {
                        // Password text placeholder is shown until user types - AF
                        TextField("P@ssw0rd!", text: $password)
                            // Password is a plain field meaning you can see user type - AF
                            .focused($inFocus, equals: .plain)
                            .padding(.horizontal)
                            .font(.system(size:16))
                        // Button was created to toggle between the fields of hidden or shown password with an icon to display which field you were in "eye.slash"- AF
                        Button(action: {
                            self.showPassword.toggle()
                            inFocus = showPassword ? .plain : .secure
                        }) { Label("", systemImage: "eye.slash")
                                .foregroundColor(Color(UIColor.lightGray))
                        }
                        .offset(x: 150, y:-45)
                    } else {
                        // Password text placeholder is shown until user types - AF
                        SecureField("P@ssw0rd!", text: $password)
                            // Password is a secure field meaning you can't see user type - AF
                            .focused($inFocus, equals: .secure)
                            .padding(.horizontal)
                            .font(.system(size:16))
                        // Button was created to toggle between the fields of hidden or shown password with an icon to display which field you were in "eye"- AF
                        Button(action: {
                            self.showPassword.toggle()
                            inFocus = showPassword ? .plain : .secure
                        }) { Label("", systemImage: "eye")
                                .foregroundColor(Color(UIColor.lightGray))
                        }
                        .offset(x: 150, y:-45)
                    }
                    // Divider was created to act as a division between the second section of the page - AF
                    Divider()
                        .padding(.horizontal)
                        .offset(y:-50)
                    
                    NavigationLink(destination: ForgotPassword()
                        .navigationBarBackButtonHidden()){
                            Text("Forgot Password?")
                                .font(Font.custom("Koulen", size: 16))
                                .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                        }
                            
                            
                            Button{
                                Task{
                                    try await viewModel.signIn(withEmail: email, password: password)                    }
                                
                            } label:{
                                HStack{
                                    Text("LOGIN")
                                        .fontWeight(.semibold)
                                    Image(systemName:"arrow.right")
                                }
                                .foregroundColor(.white)
                                .frame(minWidth: 244, maxWidth: .infinity, maxHeight:70, alignment: .center)
                            }
                            .background(Color(.systemBlue))
                            .disabled(!formIsValid)
                            .opacity(formIsValid ? 1.0 :0.5)
                            .font(Font.custom("Koulen", size: 30))
                            .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                            .background(Color(red: 0.89, green: 0.89, blue: 0.89))
                            .cornerRadius(50)
                            .padding(.horizontal)
                            .padding(.top,24);
                            
                            
                            VStack(spacing:24){
                                GoogleSiginBtn{
                                    viewModel.signinWithGoogle(presenting: getRootViewController()) { error in
                                        print("Error: \(error)")
                                    }
                                }
                            }
                    
                    // The whole VStack here was created to display the breadcrumns of the page with information pertaining to the terms of use and privacy policy with text and links to those pages which is toggable by the user to display within the application using buttons Lines 148 - 196 - AF
                            VStack(alignment: .center){
                                Divider()
                                Text("By logging into an account, you are agreeing to the")
                                    .font(Font.custom("Koulen", size: 16))
                                    .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                                HStack{
                                    Button {
                                        isTermsOfUse.toggle()
                                    } label: {
                                        Text("Terms of Use")
                                    }
                                    // Displays a sheet form the bottom of the screen which is responsive to fit half or the full screen - AF
                                    .sheet(isPresented: $isTermsOfUse) {
                                        TermsOfUse(isTermsOfUse: $isTermsOfUse)
                                            .presentationDetents([.medium, .large])
                                            .font(Font.custom("Koulen", size: 16))
                                            .multilineTextAlignment(.center)
                                    }
                                    Text("&")
                                        .font(Font.custom("Koulen", size: 16))
                                        .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                                    Button {
                                        isPrivacyPolicy.toggle()
                                    } label: {
                                        Text("Privacy Policy")
                                    }
                                    // Displays a sheet form the bottom of the screen which is responsive to fit half or the full screen - AF
                                    .sheet(isPresented: $isPrivacyPolicy) {
                                        PrivacyPolicy(isTermsOfUse: $isPrivacyPolicy)
                                            .presentationDetents([.medium, .large])
                                            .font(Font.custom("Koulen", size: 16))
                                        //.foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                            .offset(y:50)
                            
                        }
                }
            // VStack Properties (Framed, background color set, ignores the safe areas on the device, and light mode enforced) - AF
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background{Color(red: 0.89, green: 0.89, blue: 0.89)}
                .ignoresSafeArea()
                .ignoresSafeArea(.keyboard)
                // Force Light Mode - AF
                .preferredColorScheme(.light)
            }
        }
    }
    

    extension LogIn: AuthenticationFormProtocol{
        var formIsValid: Bool{
            return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 5
        }
    }
    
    struct LogIn_Previews: PreviewProvider {
        static var previews: some View {
            LogIn()
        }
    }
    

