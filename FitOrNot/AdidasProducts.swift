//
//  ChampionProducts.swift
//  FitOrNot
//
//  Created by Mustafa Marini on 10/17/23.
//



import Foundation
import SwiftUI
import SwiftSoup
import UIKit


//Adidas has logged in requirement for inspect, might have to just remove all together
struct AdidasProducts: View {
    @State private var productData: [ProductInfo] = []
    @State var gender: String = ""
    @State var clothes: String = "Hoodies"

    struct ProductInfo: Identifiable {
        let id = UUID()
        let clothesName: String
        let productURL: String
        let imageLink: String
    }

    var body: some View {
        List(productData) { info in
            Button(action: {
                openURLInSafari(urlString: info.productURL)
            }) {
                VStack {
                    Text(info.clothesName)
                    // Maybe load in image later
                }
            }
        }
        .onAppear(perform: loadData)
    }

    func loadData() {
        let adidasURL: String
        
        // For later when deciding how what clothes to display

        adidasURL = "https://www.adidas.com/us/search?q=mens%20shirts"

        fetchHTMLContent(urlString: adidasURL) { html in
            if let html = html {
                self.productData = self.extractProductInfoFromHTML(html: html)
            }
        }
    }

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

    func extractProductInfoFromHTML(html: String) -> [ProductInfo] {
        var products: [ProductInfo] = []

        do {
            let doc: Document = try SwiftSoup.parse(html)
            let elements: Elements = try doc.select("div.grid-item") //Where to scrape the items

            for element in elements.array() {
                let productLinkElement = try element.select("a").first()
                let productURL = try productLinkElement?.attr("href") ?? "" //Link when you click on item
                let productImageElement = try element.select("img").first() //Image, probably will delete
                let productImageLink = try productImageElement?.attr("src") ?? "" //Looking for Image
                let productName = try element.select("p.glass-product-card__title").text() //Name of Item

                products.append(ProductInfo(clothesName: productName, productURL: productURL, imageLink: productImageLink))
            }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }

        return products
    }

    func openURLInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct AdidasProducts_Preview: PreviewProvider {
    static var previews: some View {
        AdidasProducts()
    }
}
