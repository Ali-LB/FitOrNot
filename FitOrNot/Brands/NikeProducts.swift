//
//  NikeProducts.swift
//  FitOrNot
//
//  Created by Mustafa Marini on 10/17/23.
//

    

import SwiftUI
import UIKit
import WebKit
import Firebase
import FirebaseFirestore


struct NikeProducts: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var productData: [ProductInfo] = []
    @Binding var gender: String
    @Binding var clothes: String
    @Binding var shirt: String
    @Binding var pant: String
    @State private var webView = WKWebView()
    @State private var isLoaded = false
    @State private var isLoading = true
    @State private var nikeURL: String = ""

    
    @State private var isFeedbackNotificationPresented = false
    @State private var feedbackType: NotificationType? = .tooLarge
    @State private var tooLargeCount = 0
    @State private var tooSmallCount = 0
    
    
    struct ProductInfo: Identifiable {
        let id = UUID()
        let ariaLabel: String
        let productURL: String
        let imageLink: String
    }
    
    
    
    var body: some View {
        
       // let nikeURL = createNikeURL()
        //Hadeate a Zstack for this method to remove webpage off screen
        // geometry reader helps incorperate positioning 
        GeometryReader{ geometry in
    
            ZStack {
          
                
                VStack {
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
                                    Image("logo-nike")
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                )
                                .frame(width:90, height:90)
                                                    .background(Color.white)
                                                    .cornerRadius(50)
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
                    

                    List(productData) { info in
                        Button(action: {
                            openURLInSafari(urlString: info.productURL)
                        })
                        {
                            HStack { CachedImage(urlString: info.imageLink)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                
                                Text(info.ariaLabel)
                            }
                        }
                        
                    }//.frame(width: geometry.size.width, height: geometry.size.height / 2)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2 + 100)
                    
                   
                    
                }
                if isLoading {
                    VStack{
                        ProgressView()
                        Text("Fetching some recommended products!")
                        //Loading in the items
                    }
                }
            
            //Method of grabbing HTML items through JScript
            WebView(webView: $webView, url: URL(string: nikeURL), isLoaded: $isLoaded, onDidFinish: { webView in
                self.isLoading = false
                let script = """
         var products = [];
         var productElements = document.querySelectorAll('div.product-card');
         for (var i = 0; i < productElements.length && i < 6; i++) {
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
         """    //Runs the Jscript to fetch the items based off string script
                
                webView.evaluateJavaScript(script) { result, error in
                    if let productInfoArray = result as? [[String: String]], !productInfoArray.isEmpty {
                        self.productData = productInfoArray.map { dict in
                            ProductInfo(ariaLabel: dict["ariaLabel"] ?? "",
                                        productURL: dict["productURL"] ?? "",
                                        imageLink: dict["imageLink"] ?? "")
                        }
                    } else if let error = error {
                        print("JavaScript execution failed: \(error)")
                    }
                }
            })
            .frame(width: 0, height: 0)
            .opacity(0)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            }//.frame (width: geometry.size.width, height: geometry.size.height / 2)
            .onAppear {
            fetchNikeURL { url in
                self.nikeURL = url
                }
            }

        }
    }
    
   
    
    //Function to create URL based off Gender and Choice
    func fetchNikeURL(completion: @escaping (String) -> Void) {
            let db = Firestore.firestore()
            let docRef = db.collection("brandurls").document("brandurls")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    var field = ""

                    if self.gender == "Male" {
                        switch self.clothes {
                        case "Shirts":
                            field = "nikeMenT"
                        case "Hoodies":
                            field = "nikeMenH"
                        case "Pants":
                            field = "nikeMenB"
                        default:
                            break
                        }
                    } else {
                        switch self.clothes {
                        case "Shirts":
                            field = "nikeWomenT"
                        case "Hoodies":
                            field = "nikeWomenH"
                        case "Pants":
                            field = "nikeWomenB"
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
    
    //Function to open the button links in safari
    func openURLInSafari(urlString: String) {
        if let url = URL(string: urlString)
        {
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
       //Loads up the webpage needed to upload the images and text
struct WebView: UIViewRepresentable {
    @Binding var webView: WKWebView
    let url: URL?
    @Binding var isLoaded: Bool
    let onDidFinish: ((WKWebView) -> Void)?
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard !isLoaded, let url = url else { return } //Guards are used for early exits
        let request = URLRequest(url: url)
        uiView.load(request)
        isLoaded = true
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
            parent.onDidFinish?(webView)
        }
    }
}
         
         
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
 

/*struct NikeProducts_Preview: PreviewProvider {
    static var previews: some View {
        NikeProducts()
    }
}*/
