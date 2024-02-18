//
//  Main.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/18/23.
//

import SwiftUI
import FirebaseFirestore
import Foundation
import SwiftUI
import SwiftSoup
import UIKit
import Nuke
import WebKit

struct Main: View {
    
    @State private var navigateTo = ""
    @State private var isActive = false
    @State private var productData: [ProductInfo] = []
    @State private var pumaProductData: [ProductInfo] = []
    @State private var nikeProductData: [ProductInfo] = []

    struct ProductInfo: Identifiable {
        let id = UUID()
        let productName: String
        let productURL: String
        let imageLink: String
        var image: UIImage?
        var pumaImageLinks: [String]?

    }
    
    struct Update {
        var title: String
        var content: String
        var date: String
    }
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isDeleteConfirmed = false
    @State private var updates: [Update] = []
    @State private var webView = WKWebView()
    @State private var isLoaded = false
    @State private var isLoading = true
    @State private var nikeURL: String = ""
    
    init() {
        fetchDataFromFirestore()
    }
    //Creating a code savepoint
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
    
    
//===================================================Northface====================================================================
    
    // Function to fetch Northface URL based on Gender and Choice
        private func fetchNorthFaceURL(completion: @escaping (String) -> Void) {
            let db = Firestore.firestore()
            let docRef = db.collection("brandurls").document("brandurls")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    var field = ""

                    guard let userGender = viewModel.currentUser?.gender else { return }

                    if userGender == "Male" {
                        field = "northfacesaleMen" // Pulls the sales from database
                    } else {
                        field = "northfacesaleWomen" // Pulls the sales from database
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
    
    
    //Going through certain sections of the HTML based off the CSS Selectors to get the properties of the products
    func extractNorthfaceProductInfoFromHTML(html: String) -> [ProductInfo] {
        var products: [ProductInfo] = []
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let productElements = try doc.select("div.vf-product-card")
            for productElement in productElements.prefix(1) {
                let relativeURL = try productElement.select("a[data-v-31b0fdce]").attr("href")
                let productURL = "https://www.thenorthface.com" + relativeURL

                let productImageLink = try productElement.select("img").attr("src")
                let productName = try productElement.select("button.vf-quickshop__title").text()
                products.append(ProductInfo(productName: productName, productURL: productURL, imageLink: productImageLink))
            }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
        return products
    }
    
    // Fetch HTML content from North Face URL
    func fetchNorthFaceHTMLContent() {
        fetchNorthFaceURL { urlString in
            fetchHTMLContent(urlString: urlString) { htmlContent in
                if let html = htmlContent {
                    let productInfo = extractNorthfaceProductInfoFromHTML(html: html)
                    DispatchQueue.main.async {
                        self.productData = productInfo
                    }
                }
            }
        }
    }
    
//=======================================================Puma=====================================================================

    
    // Function to fetch Puma URL based on Gender and Choice
        private func fetchPumaURL(completion: @escaping (String) -> Void) {
            let db = Firestore.firestore()
            let docRef = db.collection("brandurls").document("brandurls")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    var field = ""

                    guard let userGender = viewModel.currentUser?.gender else { return }

                    if userGender == "Male" {
                        field = "pumasaleMen" // Pulls the sales from database
                    } else {
                        field = "pumasaleWomen" // Pulls the sales from database
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
        
        // Extract Puma product information from HTML content
        func extractPumaProductInfoFromHTML(html: String) -> [ProductInfo] {
            var products: [ProductInfo] = []
            
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let productElements = try doc.select("li[data-test-id=product-list-item]")
                
                for productElement in productElements.prefix(1) {
                    let relativeURL = try productElement.select("a[aria-disabled=false][data-test-id=product-list-item-link]").attr("href")
                    let productURL = "https://us.puma.com" + relativeURL
                    let productTitle = try productElement.select("h3").text()
                    let imageDivs = try productElement.select("img.w-full.bg-puma-black-800[src]")

                    var imageLinks = [String]()
                    for imageDiv in imageDivs {
                        let imageLink = try imageDiv.attr("src")
                        imageLinks.append(imageLink)
                    }
                    
                    // Assuming ProductInfo already has an optional property for Puma image links
                    let product = ProductInfo(productName: productTitle, productURL: productURL, imageLink: "", pumaImageLinks: imageLinks)
                    products.append(product)
                }
            } catch Exception.Error(_, let message) {
                print(message)
            } catch {
                print("error")
            }
            
            return products
        }
        
        // Fetch HTML content from Puma URL
    // Fetch HTML content from Puma URL
    func fetchPumaHTMLContent() {
        fetchPumaURL { urlString in
            fetchHTMLContent(urlString: urlString) { htmlContent in
                if let html = htmlContent {
                    let productInfo = extractPumaProductInfoFromHTML(html: html)
                    DispatchQueue.main.async {
                        // Set the pumaProductData with the Puma products
                        self.pumaProductData = productInfo
                    }
                }
            }
        }
    }
 
//========================================================Nike====================================================================

    
    
    //Caches the images that have been downloaded for later use
    class ImageCache {
        private var cache = NSCache<NSString, UIImage>()
        
        static let shared = ImageCache()
        
        func getImage(urlString: String) -> UIImage? {
            return cache.object(forKey: urlString as NSString)
        }
        
        func setImage(image: UIImage, urlString: String) {
            cache.setObject(image, forKey: urlString as NSString)
        }
    }
    
    
    //Loads the cached Images to be used
    class ImageLoader: ObservableObject {
        @Published var image: UIImage?
        private var urlString: String
        
        init(urlString: String) {
            self.urlString = urlString
            loadImage()
        }
        
        private func loadImage() {
            // Check to see if Image is already cached
            if let cachedImage = ImageCache.shared.getImage(urlString: urlString) {
                self.image = cachedImage
                return
            }
            
            // If Image is not cached, download it
            guard let url = URL(string: urlString) else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let loadedImage = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    // And then cache the downloaded image
                    ImageCache.shared.setImage(image: loadedImage, urlString: self.urlString)
                    self.image = loadedImage
                }
            }
            
            task.resume()
        }
        
    }

    //Uses the ImageLoader to get an Image from the URL String
    struct CachedImage: View {
        @ObservedObject private var loader: ImageLoader
        
        init(urlString: String) {
            loader = ImageLoader(urlString: urlString)
        }
        
        var body: some View {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
            }
            
        }
        
    }

    //Loads up the webpage needed to upload the images and text
    struct WebView: UIViewRepresentable {
        @Binding var webView: WKWebView
        let url: URL?
        @Binding var isLoaded: Bool
        var onFinishedLoading: ([Main.ProductInfo]) -> Void

        func makeUIView(context: Context) -> WKWebView {
            webView.navigationDelegate = context.coordinator
            return webView
        }

        func updateUIView(_ uiView: WKWebView, context: Context) {
            if !isLoaded, let url = url {
                let request = URLRequest(url: url)
                uiView.load(request)
                isLoaded = true
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, WKNavigationDelegate {
            var parent: WebView

            init(_ parent: WebView) {
                self.parent = parent
            }

            func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                let script = """
                var products = [];
                var productElements = document.querySelectorAll('div.product-card');
                for (var i = 0; i < 1; i++) {
                    var productElement = productElements[i];
                    var link = productElement.querySelector('a[aria-label]');
                    var img = productElement.querySelector('div.wall-image-loader img.product-card__hero-image');
                    if (link && img) {
                        products.push({
                            ariaLabel: link.getAttribute('aria-label'),
                            productURL: link.getAttribute('href'),
                            imageLink: img.getAttribute('src')
                        });
                    }
                }
                products;
                """

                webView.evaluateJavaScript(script) { result, error in
                    if let productInfoArray = result as? [[String: String]], !productInfoArray.isEmpty {
                        let products = productInfoArray.map { dict in
                            Main.ProductInfo(
                                productName: dict["ariaLabel"] ?? "",
                                productURL: dict["productURL"] ?? "",
                                imageLink: dict["imageLink"] ?? ""
                            )
                        }
                        self.parent.onFinishedLoading(products)
                    } else if let error = error {
                        print("JavaScript execution failed: \(error)")
                    }
                }
            }
        }
    }

    private func fetchNikeURL(completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("brandurls").document("brandurls")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var field = ""

                guard let userGender = viewModel.currentUser?.gender else { return }

                if userGender == "Male" {
                    field = "nikesaleMen"
                } else {
                    field = "nikesaleWomen"
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

    func extractNikeProductInfoFromHTML(html: String) -> [ProductInfo] {
        var products: [ProductInfo] = []

        do {
            let doc: Document = try SwiftSoup.parse(html)
            let productElements = try doc.select("div.product-card")

            for productElement in productElements {
                let productURL = try productElement.select("a.product-card__link-overlay").attr("href")
                guard let imageElement = try productElement.select("img.product-card__hero-image").first() else {
                    print("Error: Product image not found")
                    continue // Skip this product if the image isn't found
                }
                let imageSrc = try imageElement.attr("src")
                let productName = try productElement.select("div.product-card__title").text()

                // Print the imageSrc variable to verify its content
                print("Image source URL: \(imageSrc)")

                // Check if the image source is not empty
                if imageSrc.isEmpty {
                    print("Error: Product image source is empty for product \(productName)")
                } else {
                    let newProduct = ProductInfo(
                        productName: productName,
                        productURL: productURL,
                        imageLink: imageSrc,
                        image: ImageLoader(urlString: imageSrc).image
                    )
                    products.append(newProduct)
                }
                // Remove the break if you want to process more than the first product
                break
            }
        } catch Exception.Error(let type, let message) {
            print("Error \(type): \(message)")
        } catch {
            print("Unexpected error")
        }

        return products
    }
 
    func fetchNikeHTMLContent() {
        fetchNikeURL { urlString in
            if let url = URL(string: urlString) {
                DispatchQueue.main.async {
                    self.webView.load(URLRequest(url: url))
                    self.isLoading = true
                    self.isLoaded = false
                }
            }
        }
    }
    
//==================================================Back to Body ====================================================
   
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3) // Adjust count for the number of items in a row

    var body: some View {
        NavigationView{
            ZStack{
                
                VStack{
                    Spacer(minLength: 20)
                    // The start of the top navigation bar displaying the logo, logo header, and settings navigation link from icon with their properties lines 37 to lines 68 - AF
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
                    
                    // ScrollView is created to allow for infinite scrolling for as much elements are added to the view Lines 70 - 110 - AF
                    ScrollView{
                        // Placeholder text for the scrapped deals and image carousel for Prototype 3 - AF
                        // Placeholder text for the firebase pull of elements for the announcements/ app notes lines 81 - lines 97 - AF
                        
                        GroupBox(
                            label: Label("Announcements", systemImage: "megaphone.fill")
                                .foregroundColor(.red)
                                //.underline()
                                .bold()
                                .font(Font.custom("Koulen", size: 26))
                        ) {
                            
                            if let firstUpdate = updates.first {
                                Text(firstUpdate.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(Font.custom("Koulen", size: 22))
                                
                                Text(firstUpdate.content)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .bold()
                                //.font(Font.custom("Koulen", size: 24))
                            } else {
                                Text("No updates available")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                //.font(Font.custom("Koulen", size: 24))
                            }
                        }
                        .frame(minWidth: 0, maxWidth: 410, minHeight: 0, maxHeight: 250)
                        .padding(5)
                        /*VStack(alignment: .leading, spacing: 6) {
                         Text("Announcements")
                         .underline()
                         .bold()
                         .font(Font.custom("Koulen", size: 26))
                         
                         if let firstUpdate = updates.first {
                         Text(firstUpdate.title)
                         .frame(maxWidth: .infinity, alignment: .leading)
                         .font(Font.custom("Koulen", size: 28))
                         
                         Text(firstUpdate.content)
                         .frame(maxWidth: .infinity, alignment: .leading)
                         .font(Font.custom("Koulen", size: 24))
                         } else {
                         Text("No updates available")
                         .frame(maxWidth: .infinity, alignment: .leading)
                         .font(Font.custom("Koulen", size: 24))
                         }
                         }
                         .frame(minWidth: 0, maxWidth: 350, minHeight: 0, maxHeight: 200)
                         .padding(5)*/
                        
                        VStack{
                            //Returns the list of buttons with their Images
                            GroupBox(label: Label("Current Deals", systemImage: "dollarsign.circle.fill")
                                .foregroundColor(.red)
                                //.underline()
                                .bold()
                                .font(Font.custom("Koulen", size: 26)) ){
                                List(productData) { info in
                                    Button(action: {
                                        openURLInSafari(urlString: info.productURL)
                                    }) {
                                        HStack(spacing: 10) {
                                            Text("Northface")
                                                .frame(width: 60, alignment: .leading) // Adjusting name to align images
                                                .padding(.leading, 5)
                                            
                                            if let url = URL(string: info.imageLink) {
                                                NukeImage(url: url)
                                                    .frame(width: 100, height: 100) // keep frames all the same for items
                                                    .scaledToFit()
                                            }
                                            
                                            Text(info.productName)
                                                .padding(.leading, 5)
                                        }
                                    }
                                }
                                .scrollContentBackground(.hidden)
                                .frame(height: 200)
                                .offset(y:30)
                                //.frame(width: UIScreen.main.bounds.width, height: 200) //Changing the height of frame
                                
                                .overlay( //Loading the items in screen
                                    productData.isEmpty ?
                                    VStack {
                                        ProgressView()
                                        Text("Fetching some sweet deals!")
                                    }
                                    : nil
                                )
                                
                                // Puma is Listed Next
                                List(pumaProductData) { info in
                                    Button(action: {
                                        openURLInSafari(urlString: info.productURL)
                                    }) {
                                        HStack(spacing: 10) {
                                            Text("Puma")
                                                .frame(width: 60, alignment: .leading) // Adjust the width as needed to align Images
                                                .padding(.leading, 5)
                                            
                                            // Displaying only the first image link
                                            if let firstImageLink = info.pumaImageLinks?.first, let url = URL(string: firstImageLink) {
                                                NukeImage(url: url)
                                                    .frame(width: 100, height: 100) // frame of the Image
                                                    .scaledToFit()
                                            }
                                            
                                            Text(info.productName)
                                                .padding(.leading, 5)
                                        }
                                    }
                                }
                                .scrollContentBackground(.hidden)
                                .frame(height: 200)
                                .offset(y:-71)
                                
                                
                                
                                // List to display the scraped Nike products
                                List(nikeProductData) { product in
                                    HStack {
                                        Text("Nike")
                                            .foregroundColor(Color.blue)
                                            .frame(width: 60, alignment: .leading) // Adjust the width as needed to align the Images
                                            .padding(.leading, 5)
                                        
                                        CachedImage(urlString: product.imageLink)
                                            .frame(width: 100, height: 100)
                                            .scaledToFit()
                                        
                                        VStack(alignment: .leading) {
                                            Button(action: {
                                                openURLInSafari(urlString: product.productURL)
                                            }) {
                                                Text(product.productName)
                                                    .padding(.leading, 5)
                                            }
                                        }
                                    }
                                }
                                .scrollContentBackground(.hidden)
                                .frame(height: 200)
                                .offset(y:-150)
                                
                                
                                WebView(webView: $webView, url: URL(string: nikeURL), isLoaded: $isLoaded, onFinishedLoading: { products in
                                    self.nikeProductData = products
                                })
                                .frame(width: 0, height: 0)
                                .opacity(0)
                            
                                    Text("Keep checking back everyday for new deals, you'll never know what you might find!")
                                        .offset(y:-650)
                                        .multilineTextAlignment(.center)
                                        .bold()
                            }.frame(minWidth: 0, maxWidth: 410)
                                .padding(5)
                            .onAppear {
                                fetchNorthFaceHTMLContent()
                                fetchPumaHTMLContent()
                                fetchNikeHTMLContent()
                                fetchNikeURL { url in
                                    self.nikeURL = url
                                    isLoading = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        // A slight delay to ensure the web view is fully loaded
                                        isLoaded = true
                                    }
                                }
                            }
                            .offset(y:60)
                        }
                        .offset(y:-8)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color(red: 0.89, green: 0.89, blue: 0.89)}
            .ignoresSafeArea()
            //Force Light Mode - AF
            .preferredColorScheme(.light)
            .onAppear {
                fetchDataFromFirestore()
            }
        }
    }
    
    
    
    func fetchDataFromFirestore() {
        let db = Firestore.firestore()
        db.collection("updates").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                if let querySnapshot = querySnapshot {
                    print("Number of documents retrieved: \(querySnapshot.documents.count)")
                }
                
                var fetchedUpdates: [Update] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let title = data["title"] as? String,
                       let content = data["content"] as? String,
                       let date = data["date"] as? Timestamp {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM d, yyyy 'at' h:mm:ss a ZZZZ"
                        let formattedDate = dateFormatter.string(from: date.dateValue())
                        
                        let update = Update(title: title, content: content, date: formattedDate)
                        fetchedUpdates.append(update)
                    }
                }
                
                // Add a print statement here to debug
                print("Fetched updates: \(fetchedUpdates)")
                
                self.updates = fetchedUpdates
            }
        }
    }

    //Package used to get URL Images
    struct NukeImage: View {
        private var url: URL
        @StateObject private var imageLoader: ImageLoader

        init(url: URL) {
            self.url = url
            _imageLoader = StateObject(wrappedValue: ImageLoader(urlString: url.absoluteString))
        }
        
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
        }
    }

    //function to open safari when clicked
    func openURLInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

func placeOrder(){
    
}

#Preview {
    Main()
}
