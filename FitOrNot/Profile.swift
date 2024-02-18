//
//  Profile.swift
//  FitOrNot
//
//  Created by Ali Farhat on 9/20/23.
//

import SwiftUI
import Firebase


struct Profile: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isProfileInfoInputPresented = true
    @State private var info = "13";
    //@Binding var age: String
    @Binding var gender:String
    @Binding var neck: String
    @Binding var shoulder: String
    @Binding var sleeve: String
    @Binding var chest: String
    @Binding var waist: String
    @Binding var hips: String
    @Binding var inseam: String
    @Binding var thigh: String
    @State private var isRefreshing = false
    
    
    
    
    var body: some View {
        if let user = viewModel.currentUser{
            NavigationView{
                VStack{
                    Spacer(minLength: 20)
                    // The start of the top navigation bar displaying the logo, logo header, and settings navigation link from icon with their properties lines 37 to lines 67 - AF
                    HStack{
                        Ellipse()
                            .foregroundColor(.clear)
                            .frame(width: 126, height: 126)
                            .background(
                                Image("fitornotofficial")
                                    .resizable()
                                    .frame(width:26, height:26)
                                    .offset(x: -110, y:10)
                            )
                        
                        Text("FitOrNot")
                            .font(Font.custom("Koulen", size: 28))
                            .foregroundColor(.white)
                            .offset(x: -160, y:10)
                            .overlay(alignment: .trailing) {
                                NavigationLink {
                                    Settings()
                                }
                                label : {
                                    Image(systemName: "gear.circle")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color(UIColor.white))
                                }
                                .offset(x:60, y:10)
                                .foregroundColor(.white)
                            }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                    .background(Color(red: 0.13, green: 0.51, blue: 0.87))
                    
                    List{
                        Section{
                            HStack{
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width:72, height:72)
                                    .background(Color(red: 0.13, green: 0.51, blue: 0.87))
                                    .clipShape(Circle())
                                
                                VStack(alignment:.leading, spacing: 4){
                                    HStack{
                                        Text(user.firstName ?? "First")
                                            .fontWeight(.semibold)
                                            .padding(.top,4)
                                        Text(user.lastName ?? "Last")
                                            .fontWeight(.semibold)
                                            .padding(.top,4)
                                    }
                                    Text(user.email)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            
                        }
                        Section("User Information"){
                            VStack(alignment:.leading, spacing:12){
                               /* HStack{
                                    ProfileRowView(ImageName: "person", title: "Age", tintColor: Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    
                                    Text(age)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }*/
                                
                                HStack{
                                    ProfileRowView(ImageName: "person", title: "Gender", tintColor: Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    Text(gender)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                            }
                            
                        }
                        Section("Measurements"){
                            VStack(alignment:.leading, spacing:12){
                                HStack{
                                    ProfileRowView(ImageName: "ruler", title: "Neck", tintColor: Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    Text(user.neck != nil ? String(user.neck!) + "in" : "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                
                                HStack{
                                    ProfileRowView(ImageName: "ruler", title: "Shoulder", tintColor: Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    Text(user.shoulder != nil ? String(user.shoulder!) + "in" : "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                HStack{
                                    ProfileRowView(ImageName: "ruler", title: "Sleeves", tintColor: Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    Text(user.sleeve != nil ? String(user.sleeve!) + "in" : "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                
                                HStack{
                                    ProfileRowView(ImageName: "ruler", title: "Chest", tintColor: Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    Text(user.chest != nil ? String(user.chest!) + "in" : "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                HStack{
                                    ProfileRowView(ImageName: "ruler", title: "Waist", tintColor: Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    Text(user.waist != nil ? String(user.waist!) + "in" : "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                    
                                }
                                
                                HStack{
                                    ProfileRowView(ImageName: "ruler", title: "Hips", tintColor: Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    Text(user.hip != nil ? String(user.hip!) + "in" : "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                HStack{
                                    ProfileRowView(ImageName: "ruler", title: "Inseam", tintColor: Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    Text(user.inseam != nil ? String(user.inseam!) + "in" : "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                
                                HStack{
                                    ProfileRowView(ImageName: "ruler", title: "Thigh", tintColor: Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    Text(user.thigh != nil ? String(user.thigh!) + "in" : "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                    
                                }
                            }
                        }
                        
                        HStack{
                            Text("")
                                .font(Font.custom("Koulen", size: 16))
                                .foregroundColor(.black)
                            NavigationLink(destination: ManualMeasure()){
                                Text("Manual Inputs")
                                    .font(Font.custom("Koulen", size: 16))
                                    .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                            }
                        }
                    }
                    // Background color set for the whole list and hidden the background default color of the list Lines 221 - 222 - AF
                    .background(Color(red: 0.89, green: 0.89, blue: 0.89))
                    .scrollContentBackground(.hidden)
                    
                }
                // VStack Properties (Framed, background color set, ignore safes areas on device, hidden the back button when navigating, and light mode enforced) Lines 226 - 232 - AF
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background{
                    Color(red: 0.89, green: 0.89, blue: 0.89)}
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                //Force Light Mode - AF
                .preferredColorScheme(.light)
                
                .onAppear {
                    Task {
                        await fetchUserData()
                    }
                    
                }
            }
            
        }
        
        
    }
    func fetchUserData() async {
        await viewModel.fetchUser()
        //age = viewModel.currentUser?.age.map { String($0) } ?? ""
        gender = viewModel.currentUser?.gender ?? ""
        neck = viewModel.currentUser?.neck.map { String($0) } ?? ""
        shoulder = viewModel.currentUser?.shoulder.map { String($0) } ?? ""
        sleeve = viewModel.currentUser?.sleeve.map { String($0) } ?? ""
        chest = viewModel.currentUser?.chest.map { String($0) } ?? ""
        waist = viewModel.currentUser?.waist.map { String($0) } ?? ""
        hips = viewModel.currentUser?.hip.map { String($0) } ?? ""
        inseam = viewModel.currentUser?.inseam.map { String($0) } ?? ""
        thigh = viewModel.currentUser?.thigh.map { String($0) } ?? ""
    }
    
    struct Profile_Previews: PreviewProvider {
       // @State static var age: String = ""
        @State static var gender: String = ""
        @State static var neck: String = ""
        @State static var shoulder: String = ""
        @State static var sleeve: String = ""
        @State static var chest: String = ""
        @State static var waist: String = ""
        @State static var hips: String = ""
        @State static var inseam: String = ""
        @State static var thigh: String = ""
        
        static var previews: some View {
            Profile(/*age: $age,*/ gender: $gender, neck: $neck, shoulder: $shoulder, sleeve: $sleeve, chest: $chest, waist: $waist,
                    hips: $hips, inseam: $inseam,
                    thigh: $thigh)
        }
    }
}
