//
//  BrandAdmin.swift
//  FitOrNot
//
//  Created by Ali Farhat on 11/10/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct BrandAdmin: View {
    @State private var originalData: brandURL?
    @State private var nikeMenHoodies: String = ""
    @State private var nikeMenTops: String = ""
    @State private var nikeMenBottoms: String = ""
    @State private var nikeWomenHoodies: String = ""
    @State private var nikeWomenTops: String = ""
    @State private var nikeWomenBottoms: String = ""
    @State private var northfaceMenHoodies: String = ""
    @State private var northfaceMenTops: String = ""
    @State private var northfaceMenBottoms: String = ""
    @State private var northfaceWomenHoodies: String = ""
    @State private var northfaceWomenTops: String = ""
    @State private var northfaceWomenBottoms: String = ""
    @State private var pumaMenHoodies: String = ""
    @State private var pumaMenTops: String = ""
    @State private var pumaMenBottoms: String = ""
    @State private var pumaWomenHoodies: String = ""
    @State private var pumaWomenTops: String = ""
    @State private var pumaWomenBottoms: String = ""
    
    private var db = Firestore.firestore()
    private let collectionName = "brandurls"
    
    @State private var showingAlert = false
    
    var body: some View {
        // Scroll view displaying the list of URL settings for every brand - AF
        ScrollView{
            VStack{
                // Title Header - AF
                Text("URL Settings")
                    .bold()
                    .underline()
                    .font(.system(size: 24))
                    .fontWidth(.condensed)
                    .padding(.horizontal, 10).padding(.top, 20)
                // Nike list of both men and women URL settings - AF
                VStack{
                    Text("NIKE")
                        .bold()
                        .font(.system(size: 24))
                        .fontWidth(.condensed)
                        .padding(.horizontal, 10).padding(.top, 20)
                    VStack(alignment: .leading){
                        Text("Nike Men Hoodies")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("hoodie-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Nike Hoodies URL for men - AF
                            TextField(originalData?.nikeMenH ?? "Men - Nike Hoodies", text: $nikeMenHoodies)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    nikeMenHoodies = originalData?.nikeMenH ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Nike Men Tops")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("top-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Nike Tops URL for men - AF
                            TextField(originalData?.nikeMenT ?? "Men - Nike Tops", text: $nikeMenTops)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    nikeMenTops = originalData?.nikeMenT ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Nike Men Bottoms")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("bottom-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Nike Bottoms URL for men - AF
                            TextField(originalData?.nikeMenB ?? "Men - Nike Bottoms", text: $nikeMenBottoms)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    nikeMenBottoms = originalData?.nikeMenB ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Nike Women Hoodies")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("hoodie-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Nike Hoodies URL for women - AF
                            TextField(originalData?.nikeWomenH ?? "Women - Nike Hoodies", text: $nikeWomenHoodies)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    nikeWomenHoodies = originalData?.nikeWomenH ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Nike Women Tops")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("top-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Nike Tops URL for women - AF
                            TextField(originalData?.nikeWomenT ?? "Women - Nike Tops", text: $nikeWomenTops)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    nikeWomenTops = originalData?.nikeWomenT ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Nike Women Bottoms")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("bottom-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Nike Bottoms URL for women - AF
                            TextField(originalData?.nikeWomenB ?? "Women - Nike Bottoms", text: $nikeWomenBottoms)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    nikeWomenBottoms = originalData?.nikeWomenB ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                    }
                    Text("NORTHFACE")
                        .bold()
                        .font(.system(size: 24))
                        .fontWidth(.condensed)
                        .padding(.horizontal, 10).padding(.top, 20)
                    VStack(alignment: .leading){
                        Text("Northface Men Hoodies")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("hoodie-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for The North Face Hoodies URL for men - AF
                            TextField(originalData?.northfaceMenH ?? "Men - Northface Hoodies", text: $northfaceMenHoodies)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    northfaceMenHoodies = originalData?.northfaceMenH ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Northface Men Tops")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("top-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for The North Face Tops URL for men - AF
                            TextField(originalData?.northfaceMenT ?? "Men - Northface Tops", text: $northfaceMenTops)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    northfaceMenTops = originalData?.northfaceMenT ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Northface Men Bottoms")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("bottom-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for The North Face Bottoms URL for men - AF
                            TextField(originalData?.northfaceMenB ?? "Men - Northface Bottoms", text: $northfaceMenBottoms)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    northfaceMenBottoms = originalData?.northfaceMenB ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Northface Women Hoodies")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("hoodie-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for The North Face Hoodies URL for women - AF
                            TextField(originalData?.northfaceWomenH ?? "Women - Northface Hoodies", text: $northfaceWomenHoodies)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    northfaceWomenHoodies = originalData?.northfaceWomenH ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Northface Women Tops")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("top-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for The North Face Tops URL for women - AF
                            TextField(originalData?.northfaceWomenT ?? "Women - Northface Tops", text: $northfaceWomenTops)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    northfaceWomenTops = originalData?.nikeMenH ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Northface Women Bottoms")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("bottom-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for The North Face Bottoms URL for women - AF
                            TextField(originalData?.northfaceWomenB ?? "Women - Northface Bottoms", text: $northfaceWomenBottoms)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    northfaceWomenBottoms = originalData?.northfaceWomenB ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                    }
                    Text("PUMA")
                        .bold()
                        .font(.system(size: 24))
                        .fontWidth(.condensed)
                        .padding(.horizontal, 10).padding(.top, 20)
                    VStack(alignment: .leading){
                        Text("Puma Men Hoodies")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("hoodie-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Puma Hoodies URL for men - AF
                            TextField(originalData?.pumaMenH ?? "Men - Puma Hoodies", text: $pumaMenHoodies)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    pumaMenHoodies = originalData?.pumaMenH ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Puma Men Tops")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("top-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Puma Tops URL for men - AF
                            TextField(originalData?.pumaMenT ?? "Men - Puma Tops", text: $pumaMenTops)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    pumaMenTops = originalData?.pumaMenT ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Puma Men Bottoms")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("bottom-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Puma bottoms URL for men - AF
                            TextField(originalData?.nikeWomenB ?? "Men - Puma Bottoms", text: $pumaMenBottoms)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    pumaMenBottoms = originalData?.pumaMenB ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Puma Women Hoodies")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("hoodie-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Puma Hoodies URL for women - AF
                            TextField(originalData?.pumaWomenH ?? "Women - Puma Hoodies", text: $pumaWomenHoodies)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    pumaWomenHoodies = originalData?.pumaWomenH ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Puma Women Tops")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("top-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Puma Tops URL for women
                            TextField(originalData?.pumaWomenT ?? "Women - Puma Tops", text: $pumaWomenTops)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    pumaWomenTops = originalData?.pumaWomenT ?? ""
                                }
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                        Text("Puma Women Bottoms")
                            .bold()
                            .font(.system(size: 24))
                            .fontWidth(.condensed)
                            .padding(.horizontal, 10).padding(.top, 20)
                        HStack{
                            Image("bottom-icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 10).padding(.top, 0)
                            // Editable textfield for Puma Bottoms URL for women
                            TextField(originalData?.pumaWomenB ?? "Women - Puma Bottoms", text: $pumaWomenBottoms)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 0).padding(.top, 0)
                                .onAppear {
                                    pumaWomenBottoms = originalData?.pumaWomenB ?? ""
                                }
                        }
                    }
                    Button("Submit") {
                        updateFirebase()
                        showingAlert = true
                    }
                    .alert("Settings Saved", isPresented: $showingAlert) {
                                Button("OK", role: .cancel) { }
                            }
                    .foregroundColor(.white)
                    .frame(minWidth: 244, maxWidth: .infinity, maxHeight:70, alignment: .center)
                    .background(Color(.systemBlue))
                    .font(Font.custom("Koulen", size: 30))
                    .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
                    .background(Color(red: 0.89, green: 0.89, blue: 0.89))
                    .cornerRadius(50)
                    .padding(.horizontal)
                    .padding(.top,24);
                }
                // Once appeared fetch data of URL settings from collection on firebase
                .onAppear {
                    fetchFirebaseData()
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .padding(10)
    }
    // Function to manage and fetch URL settings from the database -AF
    func fetchFirebaseData() {
            let docRef = db.collection(collectionName).document("brandurls")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    do {
                        let data = try document.data(as: brandURL.self)
                        originalData = data
                        nikeMenHoodies = data.nikeMenH ?? ""
                        nikeMenTops = data.nikeMenT ?? ""
                        nikeMenBottoms = data.nikeMenB ?? ""
                        nikeWomenHoodies = data.nikeWomenH ?? ""
                        nikeWomenTops = data.nikeWomenT ?? ""
                        nikeWomenBottoms = data.nikeWomenB ?? ""
                        northfaceMenHoodies = data.northfaceMenH ?? ""
                        northfaceMenTops = data.northfaceMenT ?? ""
                        northfaceMenBottoms = data.northfaceMenB ?? ""
                    } catch {
                        print("Error decoding document: \(error)")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    // Function to manage and update URL settings to the database -AF
    func updateFirebase() {
            guard let originalData = originalData else {
                print("Original data not available")
                return
            }
            
            var updatedData = originalData
            updatedData.nikeMenH = nikeMenHoodies
            updatedData.nikeMenT = nikeMenTops
            updatedData.nikeMenB = nikeMenBottoms
            updatedData.nikeWomenH = nikeWomenHoodies
            updatedData.nikeWomenT = nikeWomenTops
            updatedData.nikeWomenB = nikeWomenBottoms
            updatedData.northfaceMenH = northfaceMenHoodies
            updatedData.northfaceMenT = northfaceMenTops
            updatedData.northfaceMenB = northfaceMenBottoms
            
            do {
                try db.collection(collectionName).document("brandurls").setData(from: updatedData)
                print("Data updated successfully!")
            } catch {
                print("Error updating data: \(error)")
            }
        }
    }

struct brandURL: Codable {
    var nikeMenH: String?
    var nikeMenT: String?
    var nikeMenB: String?
    var nikeWomenH: String?
    var nikeWomenT: String?
    var nikeWomenB: String?
    var northfaceMenH: String?
    var northfaceMenT: String?
    var northfaceMenB: String?
    var northfaceWomenH: String?
    var northfaceWomenT: String?
    var northfaceWomenB: String?
    var pumaMenH: String?
    var pumaMenT: String?
    var pumaMenB: String?
    var pumaWomenH: String?
    var pumaWomenT: String?
    var pumaWomenB: String?
}

#Preview {
    BrandAdmin()
}
