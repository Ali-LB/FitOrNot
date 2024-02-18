//
//  Brands.swift
//  FitOrNot
//
//  Created by Ali Farhat on 9/20/23.
//
// Fully created by Ali Farhat


import SwiftUI
import WebKit
// Lines 10 - 126 Ali Farhat
struct Brands: View {
    var body: some View {
        // UI Begins (NavigationView is used to allow navigation within the app) - AF
        NavigationView {
            VStack{
                Spacer(minLength: 20)
                // The start of the top navigation bar displaying the logo, logo header, and settings navigation link from icon with their properties lines 20 to lines 50 - AF
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
                // The list is created to display each item content in its own row displaying the header title, subtitle, and list items with navigation to each brands own inividual page with custom logos from the Assets and their own properties Lines 52 - 126 - AF
                List {
                    VStack() {
                        HStack{
                            Spacer()
                            Text("Brands")
                                .font(Font.custom("Koulen", size: 48))
                                .foregroundColor(Color.black)
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Text("We do not represent, affiliate, or sell products from any of these brands")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.black)
                                .padding(.bottom)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                    NavigationLink(destination: Nike()){
                        Label {
                            Text("Nike")
                                .bold()
                                .font(Font.custom("Koulen", size: 26))
                                .padding(.leading)
                        } icon: {
                            Image("logo-nike")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40.0)
                            
                        }
                    }.padding(8)
                    NavigationLink(destination: NorthFace()){
                        Label {
                            Text("The North Face")
                                .bold()
                                .font(Font.custom("Koulen", size: 26))
                                .padding(.leading)
                        } icon: {
                            Image("thenorthface-logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40.0)
                            //.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            
                        }
                    }.padding(8)
                    NavigationLink(destination: Puma()){
                        Label {
                            Text("Puma")
                                .bold()
                                .font(Font.custom("Koulen", size: 26))
                                .padding(.leading)
                        } icon: {
                            Image("puma-logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40.0)
                            
                        }
                    }.padding(8)
                }
                .background(Color(red: 0.89, green: 0.89, blue: 0.89))
                .scrollContentBackground(.hidden)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color(red: 0.89, green: 0.89, blue: 0.89)}
            .ignoresSafeArea()
            
        }
    }
    
}

struct Brands_Previews: PreviewProvider {
    static var previews: some View {
        Brands()
    }
}
