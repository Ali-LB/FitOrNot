
//
//  NikeProducts.swift
//  FitOrNot
//
//  Created by Mustafa Marini on 10/17/23.
//



import SwiftUI
import UIKit
import WebKit

struct NikeProducts: View {
    @State private var productData: [ProductInfo] = []
    @State var gender: String = "Male"
    @Binding var clothes: String
    @State private var webView = WKWebView()
    @State private var isLoaded = false
    @State private var isLoading = true
    
    
    struct ProductInfo: Identifiable {
        let id = UUID()
        let ariaLabel: String
        let productURL: String
        let imageLink: String
    }
    
    
    
    var body: some View {
        
        let nikeURL = createNikeURL()
        
        ZStack {
            if isLoading {
                VStack{
                    ProgressView()
                    Text("Fetching some recommended products!")
                }
            } else {
                
                
                List(productData) { info in
                    Button(action: {
                        openURLInSafari(urlString: info.productURL)
                    }) {
                        HStack { CachedImage(urlString: info.imageLink)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                            
                            Text(info.ariaLabel)
                        }
                    }
                }
            }
            
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
         """
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
            
        }
    }
    
    func createNikeURL() -> String {
        var nikeURL = ""
        if gender == "Male"
        {
            if clothes == "Shirts"
            {
                nikeURL = "https://www.nike.com/w?q=mens%20shirts&vst=mens%20shirts"
            }
            if clothes == "Hoodies"
            {
                nikeURL = "https://www.nike.com/w?q=mens%20hoodies&vst=mens%20hoodies"
            }
            if clothes == "Pants"
            {
                nikeURL = "https://www.nike.com/w?q=mens%20pants&vst=mens%20pants"
            }
        }
        else
        {
            if clothes == "Shirts"
            {
                nikeURL = "https://www.nike.com/w?q=women%20shirts&vst=women%20shirts"
            }
            
            if clothes == "Hoodies"
            {
                nikeURL = "https://www.nike.com/w?q=womens%20hoodies&vst=womens%20hoodies"
            }
            
            if clothes == "Pants"
            {
                nikeURL = "https://www.nike.com/w?q=womens%20pants&vst=womens%20pants"
            }
        }
        return nikeURL
    }
    
    func openURLInSafari(urlString: String) {
        if let url = URL(string: urlString)
        {
            UIApplication.shared.open(url)
        }
    }
    
    
}
         
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
        guard !isLoaded, let url = url else { return }
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
         
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        loadImage()
    }
    
    private func loadImage() {
        // Check if the image is already cached
        if let cachedImage = ImageCache.shared.getImage(urlString: urlString) {
            self.image = cachedImage
            return
        }
        
        // Image not cached, download it
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let loadedImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                // Cache the downloaded image
                ImageCache.shared.setImage(image: loadedImage, urlString: self.urlString)
                self.image = loadedImage
            }
        }
        
        task.resume()
    }
}
         
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
 
struct NikeProducts_Preview: PreviewProvider {
    static var previews: some View {
        @State var clothes: String = ""
                NikeProducts(clothes: $clothes)
    }
}
