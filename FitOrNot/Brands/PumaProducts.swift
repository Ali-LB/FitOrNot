//
//  PumaProducts.swift
//  FitOrNot
//
//  Created by Mustafa Marini on 10/17/23.
//

import Foundation
import SwiftUI
import SwiftSoup
import UIKit
import Nuke
import Firebase
import FirebaseFirestore
struct PumaProducts: View {
    @State private var productData: [ProductInfo] = []
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var gender: String
    @Binding var clothes: String
    @Binding var size: String
    @Binding var shirt: String
    @State private var pumaURL: String = ""

    @State private var isFeedbackNotificationPresented = false
    @State private var feedbackType: NotificationType? = .tooLarge
    @State private var tooLargeCount = 0
    @State private var tooSmallCount = 0

    struct ProductInfo: Identifiable {
        let id = UUID()
        let productName: String
        let productURL: String
        let imageLink: [String]
    }
    
    
    
    
    
    // Function to fetch Puma URL based on Gender and Choice
       private func fetchPumaURL(completion: @escaping (String) -> Void) {
           let db = Firestore.firestore()
           let docRef = db.collection("brandurls").document("brandurls")

           docRef.getDocument { (document, error) in
               if let document = document, document.exists {
                   let data = document.data()
                   var field = ""

                   if self.gender == "Male" {
                       switch self.clothes {
                       case "Shirts":
                           field = "pumaMenT"
                       case "Hoodies":
                           field = "pumaMenH"
                       case "Pants":
                           field = "pumaMenB"
                       default:
                           break
                       }
                   } else {
                       switch self.clothes {
                       case "Shirts":
                           field = "pumaWomenT"
                       case "Hoodies":
                           field = "pumaWomenH"
                       case "Pants":
                           field = "pumaWomenB"
                       default:
                           break
                       }
                   }

                   if let url = data?[field] as? String {
                       completion(url)
                   } else {
                       print("URL not found for field: \(field)")
                       completion("") // or handle error appropriately
                   }
               } else {
                   print("Document does not exist in Firestore: \(error?.localizedDescription ?? "")")
                   completion("") // or handle error appropriately
               }
           }
       }
       
    
    var body: some View {
        
        
        //Checking if HTML link can be reached
        func fetchHTMLContent(urlString: String, completion: @escaping (String?) -> Void) {
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data {
                        completion(String(data: data, encoding: .utf8))
                    } else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        completion(nil)
                    }
                }.resume()
            } else {
                completion(nil)
            }
        }
        
        //Going through certain sections of the HTML based off the CSS Selectors to get the properties of the products
        func extractProductInfoFromHTML(html: String) -> [ProductInfo] {
              var products: [ProductInfo] = []
              
              do {
                  let doc: Document = try SwiftSoup.parse(html)
                  let productElements = try doc.select("li[data-test-id=product-list-item]")
                  
                  for productElement in productElements.prefix(6){
                      let relativeURL = try productElement.select("a[aria-disabled=false][data-test-id=product-list-item-link]").attr("href")

                        let productURL = "https://us.puma.com" + relativeURL  // Prepend the domain so that the specificed URL for the product is added
                      let productTitle = try productElement.select("h3").text()
                      let imageDivs = try productElement.select("img.w-full.bg-puma-black-800[src]")

                                 var imageLinks = [String]()
                                 for imageDiv in imageDivs {
                                     let imageLink = try imageDiv.attr("src")
                                     imageLinks.append(imageLink)
                      }
                      products.append(ProductInfo(productName: productTitle, productURL: productURL, imageLink: imageLinks))
                  }
              } catch Exception.Error(_, let message) {
                  print(message)
              } catch {
                  print("error")
              }
              
              return products
          }
        
        
        
        //Returns the list of products with their Images and names
        return ZStack {
            VStack{
                ZStack{
                    LinearGradient(
                        colors: [.white],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .ignoresSafeArea()
                                
                    VStack{
                        Ellipse()
                            .foregroundColor(.clear)
                            .frame(height: 120)
                            .background(
                                Image("puma-logo")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                            )
                            .frame(width:90, height:90)
                                                .background(Color.white)
                                                .cornerRadius(25)
                                                .padding(5)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 50)
                                                        .stroke(style:
                                                                    StrokeStyle(lineWidth: 3, lineCap: .round ,dash: [7])
                                                               )
                                                        .foregroundColor(Color.black)
                                                )
                        Text("Size Recommendation: " + shirt)
                            .font(Font.custom("Koulen", size: 30))
                        Text("Not the correct sizing? Provide Feedback")
                            .offset(y:-8)
                        HStack{
                            Button("Too Large") {
                                            self.feedbackType = .tooLarge
                                            recordUserResponse()
                                            showFeedbackNotification()
                                        }
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(16)
                                        .offset(y:-28)

                                        Button("Too Small") {
                                            self.feedbackType = .tooSmall
                                            recordUserResponse()
                                            showFeedbackNotification()
                                        }
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(16)
                                        .offset(y:-28)
                        }
                        .offset(y:10)
                    }
                    .offset(y:25)
                }
                
                
                //Returns the list of buttons with their Images
                List(productData) { info in
                    Button(action: {
                        openURLInSafari(urlString: info.productURL)
                    }) {
                        HStack(spacing: 10) {  // Use HStack with spacing for better layout
                            if let firstImageLink = info.imageLink.first, let url = URL(string: firstImageLink) {
                                NukeImage(url: url)
                                    .frame(width: 100, height: 100)
                                    .scaledToFit()
                            }
                            Text(info.productName)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2 + 100)
                
                .overlay( //Loading the items in screen
                    productData.isEmpty ?
                    VStack {
                        ProgressView()
                        Text("Fetching some recommended products!")
                    }
                    : nil
                )
                
            }
            
            .onAppear {
                        fetchPumaURL { url in
                            self.pumaURL = url
                            fetchHTMLContent(urlString: url) { htmlContent in
                                if let html = htmlContent {
                                    let productInfo = extractProductInfoFromHTML(html: html)
                                    DispatchQueue.main.async {
                                        self.productData = productInfo
                                    }
                                }
                            }
                        }
                    }
            
            
            
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        

        //Package used to get URL Images
        struct NukeImage: View {
                    var url: URL

                    @StateObject private var imageLoader = ImageLoader()

                    var body: some View {
                        Group {
                            if let uiImage = imageLoader.image {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                ProgressView()
                            }
                        }
                        .onAppear {
                            imageLoader.load(url: url)
                        }
                    }
                }
                //Caches the Images to keep them static and avoid flickering
                class ImageLoader: ObservableObject {
                    @Published var image: UIImage?
                    private static let cache = NSCache<NSURL, UIImage>()

                    //Uses the URL to check that every Image is cached, sets the images to "Image"
                    func load(url: URL) {
                        if let cachedImage = Self.cache.object(forKey: url as NSURL) {
                            self.image = cachedImage
                            return
                        }
                        //Part of Nuke Package, fetches the Image and decodes it for caching
                        ImagePipeline.shared.loadImage(with: url) { result in
                            switch result {
                            case .success(let response):
                                self.image = response.image
                                Self.cache.setObject(response.image, forKey: url as NSURL)
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
          
        
        
        //function to open safari when clicked
        func openURLInSafari(urlString: String) {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
        func showFeedbackNotification() {
                isFeedbackNotificationPresented = true

                // Close the notification after a certain duration (e.g., 5 seconds)
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    isFeedbackNotificationPresented = false
                }

                // Show the feedback notification view
               if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    scene.windows.first?.rootViewController?.present(
                        UIHostingController(
                            rootView: FeedbackAlgoView(type: feedbackType!)
                        ),
                        animated: true
                    )
                }

            }

        func recordUserResponse() {
                // You can implement your logic here to record user responses
                // Display the feedback notification view
                showFeedbackNotification()

                // Count the user responses
                switch feedbackType {
                case .tooLarge:
                    tooLargeCount += 1
                    print("large count +1")
                    checkAndUpdateSize()
                case .tooSmall:
                    tooSmallCount += 1
                    print("Small count +1")
                    checkAndUpdateSize()
                default:
                    break
                }
            }

            func checkAndUpdateSize() {
                // Check if the user has recorded 3 responses for "tooLarge" or "tooSmall"
                if tooLargeCount == 3 {
                    print("Large count at 3")
                    // Update logic for too large feedback
                    handleFeedback()
                    resetCounts()
                } else if tooSmallCount == 3 {
                    print("Small count at 3")
                    // Update logic for too small feedback
                    handleFeedback()
                    resetCounts()
                }
            }

            func resetCounts() {
                tooLargeCount = 0
                tooSmallCount = 0
            }

            func handleFeedback() {
                switch feedbackType {
                case .tooLarge:
                    if shirt == "2XL" {
                            shirt = "XL"
                        } else if shirt == "XL" {
                            shirt = "L"
                        } else if shirt == "L" {
                            shirt = "M"
                        } else if shirt == "M" {
                            shirt = "S"
                        } else if shirt == "S" {
                            shirt = "XS"
                        } else if shirt == "XS" {
                            shirt = "XXS"
                        }
                    break
                case .tooSmall:
                    if shirt == "XXS" {
                            shirt = "XS"
                        } else if shirt == "XS" {
                            shirt = "S"
                        } else if shirt == "S" {
                            shirt = "M"
                        } else if shirt == "M" {
                            shirt = "L"
                        } else if shirt == "L" {
                            shirt = "XL"
                        } else if shirt == "XL" {
                            shirt = "2XL"
                        }
                    break
                case .perfect:
                    break
                default:
                    break
                }

                feedbackType = .tooLarge as NotificationType?
            }
    }
}

/*struct PumaProducts_Preview: PreviewProvider {
    static var previews: some View {
        PumaProducts()
    }
}*/

