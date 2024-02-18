//
//  PrivacyPolicy.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/16/23.
//
// Fully created by Ali Farhat

import SwiftUI

struct PrivacyPolicy: View {
    // Privacy Policy text is loaded for the filename - AF
    @ObservedObject var model: TextFileReaderModel = TextFileReaderModel(filename: "privacypolicy")
    @Binding var isTermsOfUse: Bool
    var body: some View {
        // UI Begins (NavigationView is used to allow navigation within the app) - AF
        NavigationView{
            // ScrollView is created to allow for infinite scrolling for as much elements are added to the view - AF
            ScrollView {
                // VStack is aligned as leading with a spacing of 20 - AF
                    VStack(alignment: .leading, spacing: 20) {
                        // The model loads up the data from the text file and displays it at max width within the view - AF
                            Text(model.data).frame(maxWidth: .infinity)
                            }
                            // Text Properties (Padding, Title of View, additionally a back button is created to toggle the function - AF
                            .padding()
                            .navigationBarTitle("Privacy Policy")
                            .navigationBarItems(trailing: Button(action: {isTermsOfUse.toggle()}, label: {
                                Text("Back")
                            }))
            }
        }
    }
}
