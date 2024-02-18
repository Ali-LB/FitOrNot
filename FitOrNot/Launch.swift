//
//  Launch.swift
//  FitOrNot
//
//  Created by Sartaj Gill  on 9/27/23.
//
// Lines 15 - 122 was created by Ali Farhat


import SwiftUI
import RealityKit

struct LaunchView : View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isTermsOfUse = false
    @State private var isPrivacyPolicy = false
    var body: some View {
        
        NavigationView{
            
            // In this VStack is the splash screen displaying our logo, logo header, and subheader line when the user first opens up the app with navigation links in the buttons to nvagiate users between two options from the Sign Up view or Log In View Lines 22 - 82 - AF
            VStack(alignment: .center) {
                Spacer(minLength: 150)
                Text("")
                    .background(Circle()
                            .fill(Color(red: 0.13, green: 0.51, blue: 0.87))
                            .frame(width: 5250, height: 750)
                            .offset(y:-120))
                Ellipse()
                    .foregroundColor(.clear)
                    .frame(width: 60, height: 60)
                    .background(
                        Image("fitornotofficial")
                            .resizable()
                            .frame(width:150, height:150)
                    )
                Text("FitOrNot")
                    .font(Font.custom("Koulen-Regular", size: 64))
                    .foregroundColor(.white)
                    .padding(.bottom, -100.0)
                    .offset(x: 0, y: -20)
                Text("Snap & Fit")
                    .font(Font.custom("Koulen-Regular", size: 24))
                    .offset(x: 0, y: 30)
                    .multilineTextAlignment(.center)
                    .overlay {
                        LinearGradient(
                            colors: [.red, .white],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .mask(
                            Text("Snap & Fit")
                                .font(Font.custom("Koulen-Regular", size: 24))
                                .multilineTextAlignment(.center)
                        )
                        .offset(x: 0, y: 30)
                    }
                VStack{
                    Spacer()
                    NavigationLink(destination: SignUp()){
                        Text("Sign Up")
                            .frame(width: 244, height:70, alignment: .center)
                            .font(Font.custom("Koulen", size: 30))
                            .foregroundColor(.white)
                            .background(Color(red: 0.13, green: 0.51, blue: 0.87))
                            .cornerRadius(50)
                            .padding(.bottom)
                    }
                    .offset(y:20)
                    NavigationLink(destination: LogIn()){
                        Text("Log In")
                            .frame(width: 244, height:70, alignment: .center)
                            .font(Font.custom("Koulen", size: 30))
                            .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                            .background(.white)
                            .cornerRadius(50)
                            .overlay(RoundedRectangle(cornerRadius: 50)
                                .inset(by: 0.50)
                                .stroke(Color(red: 0.13, green: 0.13, blue: 0.13)))
                    }
                    .offset(y:20)
                    
                    // The whole VStack here was created to display the breadcrumns of the page with information pertaining to the terms of use and privacy policy with text and links to those pages which is toggable by the user to display within the application using buttons Lines 85 - 130 - AF
                    VStack(alignment: .center){
                        Divider()
                        Text("By using FitOrNot, you are agreeing to the")
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
                    .offset(y:80)
                }
                .offset(y:-150)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color(red: 0.89, green: 0.89, blue: 0.89)}
            .ignoresSafeArea()
        }
    }
}

#if DEBUG
struct LaunchView_Previews : PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
#endif
