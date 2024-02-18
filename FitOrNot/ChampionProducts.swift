//
//  ChampionProducts.swift
//  FitOrNot
//
//  Created by Mustafa Marini on 10/17/23.
//

import Foundation
import Foundation
import SwiftUI
import SwiftSoup
import UIKit

struct ChampionProducts: View {
    @State private var productData: [ProductInfo] = []
    @State var gender: String = "Female"
    @State var clothes: String = "Pants"
    
    struct ProductInfo: Identifiable {
        let id = UUID()
        let productName: String
        let productURL: String
        let imageLink: String
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
        
        
        
        func extractProductInfoFromHTML(html: String) -> [ProductInfo] {
            var products: [ProductInfo] = []
            
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let productElements = try doc.select("li.product-item")
                
                for (index, productElement) in productElements.prefix(6).enumerated() {
                    let productURL = try productElement.select("a.product-item-photo").attr("href") //Link when you click on item
                    let productImageLink = try productElement.select("picture img").attr("src") //Image, again maybe delete
                    let productName = try productElement.select("a.product-item-link").attr("title") //Item Name
                    
                    products.append(ProductInfo(productName: productName, productURL: productURL, imageLink: productImageLink))
                }
            } catch Exception.Error(_, let message) {
                print(message)
            } catch {
                print("error")
            }
            
            return products
        }

        
        
        var championURL = ""
        //Deciding what to display based off user's gender and choice

        if gender == "Male"
        {
            if clothes == "Shirts"
            {
                championURL = "https://www.champion.com/catalogsearch/result/?q=mens+shirts"
            }
            if clothes == "Hoodies"
            {
                championURL = "https://www.champion.com/catalogsearch/result/?q=mens+hoodies"
            }
            if clothes == "Pants"
            {
                championURL = "https://www.champion.com/catalogsearch/result/?q=mens+pants"
            }
        }
        else {
            if clothes == "Shirts"
            {
                championURL = "https://www.champion.com/catalogsearch/result/?q=womens+shirts"
            }
            if clothes == "Hoodies"
            {
                championURL = "https://www.champion.com/catalogsearch/result/?q=womens+hoodies"
            }
            if clothes == "Pants"
            {
                championURL = "https://www.champion.com/catalogsearch/result/?q=womens+pants"
            }
        }
        if !championURL.isEmpty {fetchHTMLContent(urlString: championURL) { html in
            if let html = html {
                let productInfo = extractProductInfoFromHTML(html: html)
                productData = productInfo
            }
        }
        }
        
        
        return List(productData) { info in
            Button(action: {
                openURLInSafari(urlString: info.productURL)
            }) {
                VStack {
                    Text(info.productName)
                    // Maybe also add Images, if somehow can format them
                }
            }
        }
        
        
        
        
        
        
        func openURLInSafari(urlString: String) {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
}

struct ChamppionProducts_Preview: PreviewProvider {
    static var previews: some View {
        ChampionProducts()
    }
}
