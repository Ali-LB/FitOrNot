//
//  HTMLParser.swift
//  FitOrNot
//
//  Created by Mustafa Marini on 10/17/23.
//

import Foundation
import SwiftSoup

final class HTMLParser {
    func parse(html: String) {
        print("Got html")
        
        do{
            let document: Document = try SwiftSoup.parse(html)
            guard let body = document.body() else {
                return
            }
            
            let header = try body.getElementsByTag("h3")
            
        }
        
        catch {
            print("Error parsing" + String(describing: error))
        }
    }
}
