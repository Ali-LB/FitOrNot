//
//  NorthFace.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/6/23.
//

import SwiftUI
import FirebaseFirestore
struct NorthFace: View {
    @Environment(\.dismiss) private var dismiss
    @State var clothes: String = ""
    @State var size: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State var shirt: String = ""
    @State var pant: String = ""
    @State var gender: String = ""
    
    // Functions created to set variable clothes to the correct String to pull the correct items from scraping Lines 19 - 27 - AF
    func setBottoms() {
        clothes = "Pants"
        shirt = pant
    }
    func setHoodies() {
        clothes = "Hoodies"
    }
    func setTops() {
        clothes = "Shirts"
    }
    
    
    
    func updateUserShirt() {
        // 1. Pulls the current User's information -MM
        let currentUserMeasurements = viewModel.currentUser
        
        let genderChart = (currentUserMeasurements?.gender == "Female") ? "womenShirtSizes" : "menShirtSizes"

        
        // 2. Fetching the chart from database -MM
        
        let sizingChartRef = Firestore.firestore().collection("NorthFace_Chart").document(genderChart)
        sizingChartRef.getDocument { (document, error) in
            guard let data = document?.data(), error == nil else {
                print("Error fetching sizing chart: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            
            // 3. Converts the databse chart to float and then compares with user's info -MM
            if let currentUser = currentUserMeasurements {
                var determinedSize: String?
                for (size, measurementsData) in data {
                    if let measurementsDict = measurementsData as? [String: Any] {
                        // Now, for each key-value in the dictionary, attempt to extract the array of Floats -MM
                        var measurements: [String: [Float]] = [:]
                        for (key, value) in measurementsDict {
                            if let valueArray = value as? [NSNumber] {
                                measurements[key] = valueArray.map { Float($0) }
                            }
                        }
                        
                        // Converts the user's measurements for comparison -MM
                        let chestValue = currentUser.chest ?? 0.0
                        let hipValue = currentUser.hip ?? 0.0
                        let waistValue = currentUser.waist ?? 0.0
                        
                        
                        
                        if chestValue >= measurements["chest"]?[0] ?? 0 && chestValue <= measurements["chest"]?[1] ?? Float.infinity &&
                           hipValue >= measurements["hip"]?[0] ?? 0 && hipValue <= measurements["hip"]?[1] ?? Float.infinity &&
                           waistValue >= measurements["sleeve"]?[0] ?? 0 && waistValue <= measurements["sleeve"]?[1] ?? Float.infinity {
                            
                            determinedSize = size
                            break
                        }
                        
                        
                        else if hipValue >= measurements["hip"]?[0] ?? 0 && hipValue <= measurements["hip"]?[1] ?? Float.infinity {
                                
                                determinedSize = size
                                break
                        
                        
                    }
                    }
                    else {
                        print("Failed to typecast measurementsData. Actual type: \(type(of: measurementsData))")

                    }
                }
                
                // Moved Setting new user's size for clothing -MM
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
                    
                    print("New shirt size is " + shirt)
                    
                    
                } else {
                    print("Could not determine user's size.")
                    print(currentUser.chest)
                    

                }
                
                // Catches if the user's information is empty -MM
                if currentUser == nil {
                    print("currentUserMeasurements is nil")
                }//Catches if the user is not being pulled -MM
            } else {
                print("User not found")
            }
            
        }
    }
    
    
    
    func updateUserPants() {
        // 1. Pulls the current User's information -MM
        let currentUserMeasurements = viewModel.currentUser
        
        
        let genderChart = (currentUserMeasurements?.gender == "Female" || currentUserMeasurements?.gender == "female") ? "womenPantsSizes" : "menPantsSizes"

        
        // 2. Fetching the chart from database -MM
        
        let sizingChartRef = Firestore.firestore().collection("NorthFace_Chart").document(genderChart)
        sizingChartRef.getDocument { (document, error) in
            guard let data = document?.data(), error == nil else {
                print("Error fetching sizing chart: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            
            // 3. Converts the databse chart to float and then compares with user's info -MM
            if let currentUser = currentUserMeasurements {
                var determinedSize: String?
                for (size, measurementsData) in data {
                    if let measurementsDict = measurementsData as? [String: Any] {
                        // Now, for each key-value in the dictionary, attempt to extract the array of Floats -MM
                        var measurements: [String: [Float]] = [:]
                        for (key, value) in measurementsDict {
                            if let valueArray = value as? [NSNumber] {
                                measurements[key] = valueArray.map { Float($0) }
                            }
                        }
                        
                        // Converts the user's measurements for comparison -MM
                        let chestValue = currentUser.inseam ?? 0.0
                        let hipValue = currentUser.hip ?? 0.0
                        let waistValue = currentUser.waist ?? 0.0
                        
                        
                        
                        if chestValue >= measurements["inseam"]?[0] ?? 0 && chestValue <= measurements["inseam"]?[1] ?? Float.infinity &&
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
                
                // Moved Setting new user's size for clothing -MM
                if let determinedSize = determinedSize {
                    self.pant = determinedSize
                    if pant == "Sorry, your size is found to be too small for this brand"
                    {
                        pant = "Too small"
                    }
                    else if pant == "Sorry, your size is found to be too big for this brand"
                    {
                        pant = "Too big"
                    }
                    
                    print("New size is " + pant)
                } else {
                    print("Could not determine user's size.")
                    print(currentUser.chest)
                    

                }
                
                // Catches if the user's information is empty -MM
                if currentUser == nil {
                    print("currentUserMeasurements is nil")
                }//Catches if the user is not being pulled -MM
            } else {
                print("User not found")
            }
            
        }
    }
    
    // Lines 181 - 300 Ali Farhat
    var body: some View {
        // UI Begins (NavigationView is used to allow navigation within the app) - AF
        NavigationView{
            VStack{
                    // Logo (The Northface logo is displayed and pulled from Assets) - AF
                    Image("thenorthface-logo")
                        // Image Properties (Logo resized, scaled to fit, framed, and offset) - AF
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .offset(x:-130, y:70)
                    // Dotted border was created to encompass the header banner image northface-banner that was custom created - AF
                    Rectangle().stroke(Color.black, style: StrokeStyle(lineWidth: 5, dash: [2], dashPhase: 0))
                        // Rectangle Properties (Clear view, framed, pulling custom image, rounded corners, and offset) - AF
                        .foregroundColor(.clear)
                        .frame(height: 150)
                        .background(Image("northface-banner")
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
                        // Text Properties (Bolded, Custom font/size) - AF
                        .bold()
                        .font(Font.custom("Koulen", size: 20))
                    // List view to display navigation links and categories - AF
                    List {
                        // First Link created to display hoodies and navigation, when used .onAppear performs the setHoodies function  - AF
                        NavigationLink(destination: NorthFaceProducts(gender: $gender, clothes: $clothes, size: $size, shirt: $shirt, pant: $pant).onAppear(perform: {
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
                        NavigationLink(destination: NorthFaceProducts(gender: $gender, clothes: $clothes, size: $size, shirt: $shirt, pant: $pant).onAppear(perform: {
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
                        NavigationLink(destination: NorthFaceProducts(gender: $gender, clothes: $clothes, size: $size, shirt: $shirt, pant: $pant).onAppear(perform: {
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
                
                //Updates the user's size when the page appears -MM
                           updateUserShirt()
                            updateUserPants()
                
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
    NorthFace()
}
