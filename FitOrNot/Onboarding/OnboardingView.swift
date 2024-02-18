//
//  OnboardingView.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/25/23.
//
//  Lines 12 - 180 written by Ali Farhat
//  Lines 183 - 219 written by Sartaj

import SwiftUI
import Firebase

typealias OnboardingGetStartedAction = () -> Void

struct OnboardingView: View {
    
    // Presentation Mode is used to display the Onboarding and dismissing it once the user has finished the experience - AF
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    let item: OnboardingItem
    
    let limit: Int
    let handler: OnboardingGetStartedAction
    @Binding var index: Int
    
    //Initializor to set the values and to set our binding manually - AF
    init(item: OnboardingItem, limit: Int, index: Binding<Int>, handler: @escaping OnboardingGetStartedAction) {
        self.item = item
        self.limit = limit
        self._index = index
        self.handler = handler
    }
    
    // Variables created for the Onboarding experience for user information - AF
    var genders = ["Male", "Female"]
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var selectedGender: String = "Male"
    @State private var showAlert = false
    
    
    
    
    var body: some View {
        
        // In this VStack is how we pull out plist values and display the correct elements into each Image, Text content - AF
        VStack {
            Spacer()
            
            // Displays the sfSymbol on each Onboarding view
            Image(systemName: item.sfSymbol ?? "")
                // Image Properties (font size/weight, offset) - AF
                .font(.system(size: 100, weight: .bold))
                .offset(y:600)
            
            // Displays the Title given on each Onboarding view
            Text(item.title ?? "")
                // Text Properties (Custom font/size multilined, padded, color, offset) - AF
                .font(Font.custom("Koulen", size: 24))
                .multilineTextAlignment(.center)
                .padding(.bottom, 2)
                .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                .offset(y:400)
            
            // Displays the Content given on each Onboarding view
            Text(item.content ?? "")
                // Text Properties (Custom font/size multilined, padded, color, offset) - AF
                .font(Font.custom("Koulen", size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                .offset(y:580)
            
            // Displays the sfSymbol given on each Onboarding view
            Image(item.sfSymbol ?? "")
                // Image Properties (font size/weight, offset) - AF
                .font(.system(size: 40, weight: .bold))
                .offset(y:20)
            
            // VStack was created to show the input variables for the user account update on the last page - AF
            VStack(spacing:24){
                
                // Asks for user to input First Name - AF
                InputView(text: $firstName, title: "First Name", placeholder: "John")
                    .offset(y:450)
                // Asks for user to input Last Name - AF
                InputView(text: $lastName, title: "Last Name", placeholder: "Doe")
                    .offset(y:450)
                
                HStack{
                    Text("I am a: ")
                        .font(Font.custom("Koulen", size: 16))
                        .multilineTextAlignment(.center)
                        .opacity(index == 2 ? 1 : 0)
                    
                    // User can pick between two options Male, Female from the selectedGender array - AF
                    Picker(
                        selection: $selectedGender,
                        label:
                            HStack{
                                Text("Gender: ")
                                Text(selectedGender)
                            }
                            // HStack Properties (font: headline, color set as white, background set as blue, with a shadow, and rounded edges - AF
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(color: Color.blue.opacity(0.3), radius: 10)
                        , content: {
                                ForEach(genders, id: \.self){ option in
                            Text(option)
                                .tag(option)
                        }
                    })
                    // Picker Properties (Custom font, Pickerstyle, Opacity: Display on view 3, AllowHitTesting: Makes it interactive, Animation, and padding  - AF
                    .font(Font.custom("Koulen", size: 14))
                    .pickerStyle(MenuPickerStyle())
                    .opacity(index == 2 ? 1 : 0)
                    .allowsHitTesting(index == 2)
                    .animation(.easeInOut(duration: 0.25), value: 1)
                    .padding()
                    
                }
                .offset(y:450)
                Button(action: {
                    Task{
                        await saveUserInformationToFirestore()
                    }
                    
                    // To dismiss the Onboarding when pressed - AF
                    presentationMode.wrappedValue.dismiss()
                    handler()
                }, label: {
                    Text("Get Started!")
                })
                // Text Button Properties (Custom font, color set as white, rounded edges, within a frame, background color set, padding, offset, allowsHitTesting: Makes it interactive, Animation - AF
                .font(Font.custom("Koulen", size: 32))
                .foregroundColor(.white)
                .cornerRadius(20)
                .frame(minWidth: 244, maxWidth: .infinity, maxHeight:370, alignment: .center)
                .background(Color(red: 0.13, green: 0.51, blue: 0.87))
                .padding(.top, 50)
                .offset(y:500)
                .opacity(index == 2 ? 1 : 0)
                .allowsHitTesting(index == 2)
                .animation(.easeInOut(duration: 0.25), value: 1)
            }
            // VStack Properties (offset, padding, Opacity: Only appears on the third Onboarding view) - AF
            .offset(y:100)
            .padding(.horizontal)
            .padding(.top, 12)
            .opacity(index == 2 ? 1 : 0)
            
            // Custom image created for the first splash screen on the Onboarding pulling onboarding-splash-cropped from the Assets folder.
            Image("onboarding-splash-cropped")
                //Image Properties (Image resizable, aspectRatio: Fit to edge to edge, padding, Opacity: Only appears on the second Onboarding view, offset) - AF
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(.top, 10)
                .opacity(index == 0 ? 1 : 0)
                .offset(y:200)

            // Custom image created for the second splash screen on the Onboarding pulling onboarding-brands-cropped from the Assets folder.
            Image("onboarding-brands-cropped")
                //Image Properties (Image resizable, aspectRatio: Fit to edge to edge, padding, Opacity: Only appears on the first Onboarding view, offset) - AF
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(.top, 10)
                .opacity(index == 1 ? 1 : 0)
                .offset(y:-370)
            

        }
        // VStack Properties (Background color set, and ignore safe areas of the device screen) - AF
        .background{
            Color(red: 0.89, green: 0.89, blue: 0.89)}
        .ignoresSafeArea()
    }
    
    func saveUserInformationToFirestore() async {
        do {
            await viewModel.fetchUser()
            print("User fetched from Firestore: \(viewModel.currentUser)")

            if let user = viewModel.currentUser {
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(user.id)

                var updatedData: [String: Any] = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "gender": selectedGender
                ]
                print("First Name: \(firstName)")
                print("Last Name: \(lastName)")

                await userRef.setData(updatedData, merge: true, completion: { error in
                    if let error = error {
                        print("Error updating user data: \(error.localizedDescription)")
                    } else {
                        print("User data updated successfully.")
                    }
                })
            } else {
                print("viewModel.currentUser is nil")
            }

            
            await viewModel.fetchUser()
            print("User fetched from Firestore: \(viewModel.currentUser)")
        } catch {
            print("Failed to update user data: \(error.localizedDescription)")
        }
    }

}


/*struct OnboardingView_Previews: PreviewProvider{
    static var previews: some View {
        OnboardingView(item: OnboardingItem(title: "dummy", content: "dummy content", sfSymbol: "heart"), limit:0, index: .constant(0)) {}
    }
}*/

