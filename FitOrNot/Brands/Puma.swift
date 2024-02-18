//
//  Puma.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/6/23.
//

import SwiftUI
import FirebaseFirestore

struct Puma: View {
    @Environment(\.dismiss) private var dismiss
    @State var clothes: String = ""
    @State var size: String = ""
    @State var shirt: String = ""
    @State var gender: String = ""
    @EnvironmentObject var viewModel: AuthViewModel

    // Functions created to set variable clothes to the correct String to pull the correct items from scraping Lines 19 - 27 - AF
    func setBottoms() {
        clothes = "Pants"
    }
    func setHoodies() {
        clothes = "Hoodies"
    }
    func setTops() {
        clothes = "Shirts"
    }
    
    
    
    func updateUserShirt() {
        // 1. Pulls the current User's information
        let currentUserMeasurements = viewModel.currentUser
        
        let genderChart = (currentUserMeasurements?.gender == "Female" || currentUserMeasurements?.gender == "female") ? "womenSizes" : "menSizes"

        
        // 2. Fetching the chart from database
        
        let sizingChartRef = Firestore.firestore().collection("Puma_Chart").document(genderChart)
        sizingChartRef.getDocument { (document, error) in
            guard let data = document?.data(), error == nil else {
                print("Error fetching sizing chart: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            
            // 3. Converts the databse chart to float and then compares with user's info
            if let currentUser = currentUserMeasurements {
                var determinedSize: String?
                for (size, measurementsData) in data {
                    if let measurementsDict = measurementsData as? [String: Any] {
                        // Goes through each map and finds its float values
                        var measurements: [String: [Float]] = [:]
                        for (key, value) in measurementsDict {
                            if let valueArray = value as? [NSNumber] {
                                measurements[key] = valueArray.map { Float($0) }
                            }
                        }
                        
                        // Converts the user's measurements for comparison
                        let chestValue = currentUser.chest ?? 0.0
                        let hipValue = currentUser.hip ?? 0.0
                        let waistValue = currentUser.waist ?? 0.0
                        
                        
                        //Compares the user's values with that of the sizes, sets 0 to default min and infinity to default max if size chart is empty
                        if chestValue >= measurements["chest"]?[0] ?? 0 && chestValue <= measurements["chest"]?[1] ?? Float.infinity &&
                           hipValue >= measurements["hip"]?[0] ?? 0 && hipValue <= measurements["hip"]?[1] ?? Float.infinity &&
                           waistValue >= measurements["waist"]?[0] ?? 0 && waistValue <= measurements["waist"]?[1] ?? Float.infinity {
                            
                            determinedSize = size
                            break
                        }
                        
                        else if waistValue >= measurements["waist"]?[0] ?? 0 && waistValue <= measurements["waist"]?[1] ?? Float.infinity {
                                
                                determinedSize = size
                                break
                        
                        
                    }
                        
                    }
                    else {
                        print("Failed to typecast measurementsData. Actual type: \(type(of: measurementsData))")

                    }
                }
                
                // Moved Setting new user's size for clothing
                if let determinedSize = determinedSize {
                    self.shirt = determinedSize
                    
                    if shirt == "Sorry, your size is found to be too small for this brand"
                    {
                        shirt = "Too small"
                    }
                    else if shirt == "Sorry, your size is found to be too big for this brand"
                    {
                        shirt = "Too big"
                    }
                    print("New size is " + shirt)
                } else {
                    print("Could not determine user's size.")
                    print(currentUser.chest)
                    

                }
                
                // Catches if the user's information is empty
                if currentUser == nil {
                    print("currentUserMeasurements is nil")
                }//Catches if the user is not being pulled
            } else {
                print("User not found")
            }
            
        }
    }
    
    
    // Lines 106 - 225 Ali Farhat
    var body: some View {
        // UI Begins (NavigationView is used to allow navigation within the app) - AF
        NavigationView{
            VStack{
                    // Logo (Niki logo is displayed and pulled from Assets) - AF
                    Image("puma-logo")
                        // Image Properties (Logo resized, scaled to fit, framed, and offset) - AF
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .offset(x:-130, y:70)
                    // Dotted border was created to encompass the header banner image puma-banner that was custom created - AF
                    Rectangle().stroke(Color.black, style: StrokeStyle(lineWidth: 5, dash: [2], dashPhase: 0))
                        // Rectangle Properties (Clear view, framed, pulling custom image, rounded corners, and offset) - AF
                        .foregroundColor(.clear)
                        .frame(height: 150)
                        .background(Image("puma-banner")
                            .resizable(capInsets: /*@START_MENU_TOKEN@*/EdgeInsets(), resizingMode: .stretch/*@END_MENU_TOKEN@*/)
                            .aspectRatio(contentMode: .fill))
                        .cornerRadius(20)
                        .padding(10)
                        .offset(y:50)
                // Within the banner is custom Text displaying motto - AF
                Text("Your Fit\nYour Way")
                        // Text Properties (Custom font/size, color set to white, and offset0 - AF
                        .font(Font.custom("Koulen", size: 40))
                        .foregroundColor(.white)
                        .offset(x: -100, y: -135)
                VStack{
                    // Text displaying subheadline Choose a category - AF
                    Text("Choose a category")
                        // Text Properties (Bolded, Custom font/size) - AF/
                        .bold()
                        .font(Font.custom("Koulen", size: 20))
                    // List view to display navigation links and categories - AF
                    List {
                        // First Link created to display hoodies and navigation, when used .onAppear performs the setHoodies function  - AF
                        NavigationLink(destination: PumaProducts(gender: $gender, clothes: $clothes, size: $size, shirt: $shirt).onAppear(perform: {
                            setHoodies()
                        }
                    )){
                            Label {
                                        // Labeled as Hoodies in the list - AF
                                        Text("Hoodies")
                                            // Text Properties (Bolded, custom font/size, and padding) - AF
                                            .bold()
                                            .font(Font.custom("Koulen", size: 20))
                                            .padding(.leading)
                                    } icon: {
                                        // Custom hoodie icon was pulled from the Assets - AF
                                        Image("hoodie-icon")
                                            // Image Properties (Resized, scaled to fit, and framed) - AF
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40.0)
                                        
                                    }
                            // List item padded to the size of 8 all around - AF
                        }.padding(8)
                        // Second Link created to display tops and navigation, when used .onAppear performs the setTops function  - AF
                        NavigationLink(destination: PumaProducts(gender: $gender, clothes: $clothes, size: $size, shirt: $shirt).onAppear(perform: {
                            setTops()
                        }
                    )){
                            Label {
                                        // Labeled as Tops in the list - AF
                                        Text("Tops")
                                        // Text Properties (Bolded, custom font/size, and padding) - AF
                                            .bold()
                                            .font(Font.custom("Koulen", size: 20))
                                            .padding(.leading)
                                    } icon: {
                                        // Custom shirt icon was pulled from the Assets - AF
                                        Image("top-icon")
                                            // Image Properties (Resized, scaled to fit, and framed) - AF
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40.0)
                                        
                                    }
                            // List item padded to the size of 8 all around - AF
                        }.padding(8)
                        // Third Link created to display bottoms and navigation, when used .onAppear performs the setBottoms function - AF
                        NavigationLink(destination: PumaProducts(gender: $gender, clothes: $clothes, size: $size, shirt: $shirt).onAppear(perform: {
                            setBottoms()
                        }
                    )){
                            Label {
                                        // Labeled as Bottoms in the list - AF
                                        Text("Bottoms")
                                            // Text Properties (Bolded, custom font/size, and padding) - AF
                                            .bold()
                                            .font(Font.custom("Koulen", size: 20))
                                            .padding(.leading)
                                    } icon: {
                                        // Custom pants icon was pulled from the Assets - AF
                                        Image("bottom-icon")
                                            // Image Properties (Resized, scaled to fit, and framed) - AF
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40.0)
                                        
                                    }
                            // List item padded to the size of 8 all around - AF
                        }.padding(8)
                    }
                    .offset(y:-30)
                }
                // List Properties (Background color set, Content background color is clear, and offset) - AF
                .background(Color(red: 0.89, green: 0.89, blue: 0.89))
                .scrollContentBackground(.hidden)
                .offset(y:-100)
            }
            // VStack Properties (Framed, background color set, ignores the safe areas on the device, Light mode enforced) - AF
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color(red: 0.89, green: 0.89, blue: 0.89)}
            .ignoresSafeArea()
            //Force Light Mode - AF
            .preferredColorScheme(.light)
            .onAppear(perform: {
                           updateUserShirt()
                
                if let currentUser = viewModel.currentUser, let userGender = currentUser.gender {
                    gender = userGender
                }
                
                       })
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
                    // 1
                    .toolbar {

                        // 2
                        ToolbarItem(placement: .navigationBarLeading) {

                            Button {
                                // 3
                                print("Custom Action")
                                dismiss()

                            } label: {
                                // 4
                                HStack {

                                    Image(systemName: "chevron.backward")
                                    Text("Brands")
                                }
                            }
                        }
                    }
    }
}
#Preview {
    Puma()
}
