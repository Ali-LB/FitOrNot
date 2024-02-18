//
//  TermsOfUse.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/15/23.
//
// Fully created by Ali Farhat

import SwiftUI

// TextFileReaderModel class is used to load and display the contents of a text file ie. privacypolicy & termsofuse under the text folder which I also had created for this project - AF
class TextFileReaderModel: ObservableObject {
    // Store the loaded text file contents - AF
    @Published public var data: LocalizedStringKey = ""
    
    // A method that accepts a filename parameter and calls a load(file:) method, passing in the filename - AF
    init(filename: String) { self.load(file: filename) }

    // Function load was created to get the file path for the given filename from the app's main bundle. - AF
    func load(file: String) {
        
        // If the path is found, it initializes the String from the file contents using the contentsOfFile from Foundation. - AF
        if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
            // Pushs the reading of the file to the main thread and notifies when the object data has changed - AF
            do {
                let contents = try String(contentsOfFile: filepath)
                DispatchQueue.main.async {
                    self.data = LocalizedStringKey(contents)
                }
                // In case of any errors an error is displayed - AF
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            // In case of a file missing an error is displayed - AF
        } else {
            print("File not found")
        }
    }
}

struct TermsOfUse: View {
    // Terms of Use text is loaded for the filename - AF
    @ObservedObject var model: TextFileReaderModel = TextFileReaderModel(filename: "termsofuse")
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
                            .navigationBarTitle("Terms of Use")
                            .navigationBarItems(trailing: Button(action: {isTermsOfUse.toggle()}, label: {
                                Text("Back")
                            }))
            }
        }
    }
}
