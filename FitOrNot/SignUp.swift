//
//  SignUp.swift
//  FitOrNot
//
//  Created by Ali Farhat on 9/20/23.
//

import SwiftUI
import Firebase

struct SignUp: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var isAccountCreated = false
    
    // isTermsOfUse and isPrivacyPolicy was created to toggle activating the sheet to display the file on screen Lines 18 - 19 - AF
    @State private var isTermsOfUse = false
    @State private var isPrivacyPolicy = false
    
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    // inFocus was created to toggle between the hidden password and show password fields as well as showPassword to toggle between them Lines 25 - 26 - AF
    @FocusState var inFocus: Field?
    @State private var showPassword: Bool = false
    
    // The fields used for inFocus to toggle the textfield is either secure or plain for displaying the password to the user Lines 29 - 31 - AF
    enum Field {
        case secure, plain
    }
    
    // The password requirements that check as a boolean whenever the user inputs in the password field for having this criteria Lines 34 - 40 - AF
    private var requirements: Array<Bool> {
        [
            password.count >= 7,
            password &= "[0-9]",
            password &= ".*[^A-Za-z0-9].*"
        ]
    }
    // Lines 43 - 68 Ali Farhat 
    var body: some View {
        VStack{
            // VStack is aligned as leading - AF
            VStack(alignment: .leading){
                // Text displaying Sign Up header
                Text("SIGN UP")
                    // Text Properties (Custom font/size, color set, and offset) - AF
                    .font(Font.custom("Koulen", size: 32))
                    .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                    .offset(x: 20, y: 10)
                // Underneath the header there is a subheader linking to the login page with a subline - AF
                HStack{
                    // Text displaying Already have an account - AF
                    Text("Already have an account?")
                        // Text Properties (Custom font/size, color set to black) - AF
                        .font(Font.custom("Koulen", size: 16))
                        .foregroundColor(.black)
                    // Navigation link for the text Log In if interacted takes user to the Log In View with the back button hidden - AF
                    NavigationLink(destination: LogIn()
                        .navigationBarBackButtonHidden()){
                        Text("Log In")
                            // Text Properties (Custom font/size, color set) - AF
                            .font(Font.custom("Koulen", size: 16))
                            .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                    }
                }
                .offset(x:20, y:5)
                VStack(spacing:24){
                    //InputView(text: $fullname, title: "Full Name", placeholder: "John Doe")
                    
                    InputView(text: $email, title: "Email Address", placeholder: "email@example.com")
                        .autocapitalization(.none)
                    
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
                        //.padding(.horizontal)
                        .offset(y:-50)
                    
                        
                    }
                .padding(.horizontal)
                .padding(.top, 12); 
                
                // The VStack shows the password requirements for users to have to fill out, as soon as users fill each requirement the text color will change from the original red font to green font satisfying each requirement Lines 123 - 142 - AF
                VStack(alignment: .leading, spacing: 5){
                                HStack{
                                    Text("Your password must contain at least:")
                                        .foregroundColor(.black)
                                        .padding(.leading, 20)
                                        .font(Font.custom("Koulen", size: 12))
                                    Spacer()
                                }
                                Group{
                                    Text("• 7 characters")
                                        .foregroundColor(self.requirements[0] ? .green : .red)
                                    Text("• 1 number")
                                        .foregroundColor(self.requirements[1] ? .green : .red)
                                    Text("• 1 special character(! @ # $ % ^ *)")
                                        .foregroundColor(self.requirements[2] ? .green : .red)
                                }
                                .padding(.leading, 60)
                                .font(Font.custom("Koulen", size: 12))
                            }
                .offset(y:-50)
                Button{
                    Task{
                        try await viewModel.createUser(withEmail: email, password: password/*, fullname: fullname*/)
                        isAccountCreated = true
                    }
                } label:{
                    HStack{
                        Text("REGISTER")
                            .fontWeight(.semibold)
                        Image(systemName:"arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(minWidth: 244, maxWidth: .infinity, maxHeight:70, alignment: .center)
                }
                // Button Properties Lines 158, 161 - 166 AF
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 :0.5)
                .font(Font.custom("Koulen", size: 30))
                .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                .background(Color(red: 0.89, green: 0.89, blue: 0.89))
                .cornerRadius(50)
                .padding(.horizontal)
                .padding(.top,24);
                
                
                // The whole VStack here was created to display the breadcrumns of the page with information pertaining to the terms of use and privacy policy with text and links to those pages which is toggable by the user to display within the application using buttons Lines 170 - 224 - AF
                VStack(alignment: .center){
                    Divider()
                    Text("By registering an account, you are agreeing to the")
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
                        .multilineTextAlignment(.center)
                    }
                }
                }
                
                .offset(y:50)
            }
            // VStack Properties (Framed, background color set, ignores the safe areas on the device, and light mode enforced) - AF
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color(red: 0.89, green: 0.89, blue: 0.89)}
            .ignoresSafeArea()
        }
        // Force Light Mode - AF
        .preferredColorScheme(.light)
        .alert(isPresented: $isAccountCreated) {
                    Alert(
                        title: Text("Account Created"),
                        message: Text("Your account has been successfully created."),
                        dismissButton: .default(Text("OK")) {
                        }
                    )
                }
    }
    func register(){
            isAccountCreated = true
            Auth.auth().createUser(withEmail: email, password: password) {result, error in
                if error != nil {
                    print(error!.localizedDescription)
                }
            }
        }

}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}

extension SignUp: AuthenticationFormProtocol{
    var formIsValid: Bool{
        let passwordCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_+=-[]{}|:;\"',.<>?/~")
        
        return !email.isEmpty
        && email.contains("@")
        && password.rangeOfCharacter(from: passwordCharacterSet) != nil
        && !password.isEmpty
        && password.count > 6
    }
}

extension String {
    static func &= (lhs: String, rhs: String) -> Bool {
        return lhs.range(of: rhs,options: .regularExpression) != nil
    }
}
extension View {
    func placeholder<Content: View>( when shouldShow: Bool, alignment: Alignment = .leading, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1:0)
            self
                .offset(x:20)
        }
    }
}
