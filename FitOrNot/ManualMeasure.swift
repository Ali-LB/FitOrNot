//
//  ManualMeasure.swift
//  FitOrNot
//
//  Created by Mustafa Marini on 9/28/23.
//

import SwiftUI
import Firebase
import Combine
import FirebaseFirestore

struct ManualMeasure: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var info = "13";
    //@State var age: String = ""
    //@State var ageInt : Int = 0
    @State var gender: String = ""
    @State var neck: String = ""
    @State var shoulder: String = ""
    @State var sleeve: String = ""
    @State var chest: String = ""
    @State var waist: String = ""
    @State var hip: String = ""
    @State var inseam: String = ""
    @State var thigh: String = ""
    @State private var navigateToProfile = false
    @State var height: String = ""
    @State var size: String = ""
    @State private var isHidden = true

    
    var body: some View {
        if let user = viewModel.currentUser{
            List{
                Section{
                    HStack{
                        
                        VStack(alignment:.leading, spacing: 4){
                            Text("Manual Measurement Entry")
                                .fontWeight(.semibold)
                                .padding(.top,4)
                        }
                    }
                    
                    
                }
                Section("User Information"){
                    VStack(alignment:.leading, spacing:12){
                        /*HStack{
                            ProfileRowView(ImageName: "person", title: "Age", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            TextField("Ex. 22", text: $age)
                                                            .font(.subheadline)
                                                            .foregroundColor(age.isEmpty ? .gray : .primary) // Change text color
                                                            .multilineTextAlignment(.trailing)
                                                            .onAppear {
                                                                age = user.age.map { String($0) } ?? "" // Set placeholder
                                                            }
                            
                        }*/
                        
                        HStack{
                            ProfileRowView(ImageName: "person", title: "Gender", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            Picker("Gender", selection: $gender) {
                                            Text("Male").tag("Male")
                                            Text("Female").tag("Female")
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                        .onAppear {
                                            gender = user.gender ?? ""
                                        }
                        }
                        
                    }
                    
                }
                Section("Measurements"){
                    VStack(alignment:.leading, spacing:12){
                        HStack{
                            ProfileRowView(ImageName: "ruler", title: "Neck", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            TextField("Ex. 12", text: $neck)
                                        .font(.subheadline)
                                        .foregroundColor(neck.isEmpty ? .gray : .primary)
                                        .multilineTextAlignment(.trailing)
                                        .onAppear {
                                            neck = user.neck.map { String($0) } ?? ""
                                        }
                        }
                        
                        HStack{
                            ProfileRowView(ImageName: "ruler", title: "Shoulder", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            TextField("Ex. 12", text: $shoulder)
                                        .font(.subheadline)
                                        .foregroundColor(shoulder.isEmpty ? .gray : .primary)
                                        .multilineTextAlignment(.trailing)
                                        .onAppear {
                                            shoulder = user.shoulder.map { String($0) } ?? ""
                                        }
                        }
                        HStack{
                            ProfileRowView(ImageName: "ruler", title: "Sleeves", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            TextField("Ex. 12", text: $sleeve)
                                        .font(.subheadline)
                                        .foregroundColor(sleeve.isEmpty ? .gray : .primary)
                                        .multilineTextAlignment(.trailing)
                                        .onAppear {
                                            sleeve = user.sleeve.map { String($0) } ?? ""
                                        }
                        }
                        
                        HStack{
                            ProfileRowView(ImageName: "ruler", title: "Chest", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            TextField("Ex. 12", text: $chest)
                                        .font(.subheadline)
                                        .foregroundColor(chest.isEmpty ? .gray : .primary)
                                        .multilineTextAlignment(.trailing)
                                        .onAppear {
                                            chest = user.chest.map { String($0) } ?? "" 
                                        }
                        }
                        HStack{
                            ProfileRowView(ImageName: "ruler", title: "Waist", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            TextField("Ex. 12", text: $waist)
                                        .font(.subheadline)
                                        .foregroundColor(waist.isEmpty ? .gray : .primary)
                                        .multilineTextAlignment(.trailing)
                                        .onAppear {
                                            waist = user.waist.map { String($0) } ?? ""
                                        }
                        }
                        
                        HStack{
                            ProfileRowView(ImageName: "ruler", title: "Hips", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            TextField("Ex. 12", text: $hip)
                                        .font(.subheadline)
                                        .foregroundColor(hip.isEmpty ? .gray : .primary)
                                        .multilineTextAlignment(.trailing)
                                        .onAppear {
                                            hip = user.hip.map { String($0) } ?? ""
                                        }
                        }
                        HStack{
                            ProfileRowView(ImageName: "ruler", title: "Inseam", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            TextField("Ex. 12", text: $inseam)
                                        .font(.subheadline)
                                        .foregroundColor(inseam.isEmpty ? .gray : .primary)
                                        .multilineTextAlignment(.trailing)
                                        .onAppear {
                                            inseam = user.inseam.map { String($0) } ?? ""
                                        }
                        }
                        
                        HStack{
                            ProfileRowView(ImageName: "ruler", title: "Thigh", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            TextField("Ex. 12", text: $thigh)
                                        .font(.subheadline)
                                        .foregroundColor(thigh.isEmpty ? .gray : .primary)
                                        .multilineTextAlignment(.trailing)
                                        .onAppear {
                                            thigh = user.thigh.map { String($0) } ?? ""
                                        }
                            
                        }
                        
                        
                    }
                    
                }
                Button{
                    Task{
                        updateMeasurementsAndAge()
                        navigateToProfile = true
                          }
                    
                                    } label:{
                    HStack{
                        Text("Update Measurements")
                            .fontWeight(.semibold)
                        Image(systemName:"arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width:UIScreen.main.bounds.width - 40, height:48)
                }
                .navigationBarBackButtonHidden(true)
                .background(Color(.systemBlue))
                .cornerRadius(10)
                .padding(.horizontal)
                
                
            }
            
            NavigationLink("", destination: Profile(/*age: $age,*/ gender: $gender, neck: $neck, shoulder: $shoulder, sleeve: $sleeve, chest: $chest, waist: $waist, hips: $hip, inseam: $inseam, thigh: $thigh).environmentObject(viewModel).navigationBarBackButtonHidden(true), isActive: $navigateToProfile)

            
            
            
        }
        
        /*VStack{
         VStack(alignment: .leading){
         Text("Username")
         .font(Font.custom("Koulen", size: 32))
         .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
         HStack{
         Text("Profile")
         .font(Font.custom("Koulen", size: 16))
         .foregroundColor(.black)
         
         }
         }
         .offset(x: -105, y: -250)
         .preferredColorScheme(.light)
         }*/
        

    }
    
    func updateMeasurementsAndAge() {
            if let user = viewModel.currentUser {
                guard
                      let neckFloat = Float(neck),
                      let shoulderFloat = Float(shoulder),
                      let sleeveFloat = Float(sleeve),
                      let chestFloat = Float(chest),
                      let waistFloat = Float(waist),
                      let hipFloat = Float(hip),
                      let inseamFloat = Float(inseam),
                      let thighFloat = Float(thigh)
                        else {
                    print("Failed to convert data to the correct format")
                    return
                }

                let updatedUser = User(
                    id: user.id,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    email: user.email,
                    gender: gender,
                    neck: neckFloat,
                    shoulder: shoulderFloat,
                    sleeve: sleeveFloat,
                    chest: chestFloat,
                    waist: waistFloat,
                    hip: hipFloat,
                    inseam: inseamFloat,
                    thigh: thighFloat
                )

                do {
                    let encodedUser = try Firestore.Encoder().encode(updatedUser)
                    Firestore.firestore().collection("users").document(user.id).setData(encodedUser) { error in
                        if let error = error {
                            print("Failed to update user data: \(error.localizedDescription)")
                        } else {
                            print("User data updated successfully.")
                        }
                    }
                } catch {
                    print("Failed to encode user data: \(error.localizedDescription)")
                }
            }
        }




}





struct Manual_Previews: PreviewProvider {
    static var previews: some View {
        ManualMeasure()
    }
}
