//
//  OnboardingItem.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/25/23.
//
// Fully created this page - Ali Farhat

import Foundation

struct OnboardingItem: Codable, Identifiable {
    // Variables to pull elements into using String and their ID listed from OnboardingContent plist - AF
    var id = UUID()
    var title: String?
    var content: String?
    //var image: String?
    var sfSymbol: String?
    
    // Coding keys for our codable objects - AF
    enum CodingKeys: String, CodingKey {
        case title, content, sfSymbol
    }
    // initializor this with dummy content for our previews - AF
    init(title: String? = nil, content: String? = nil, sfSymbol: String? = nil) {
        self.title = title
        self.content = content
        //self.image = image
        self.sfSymbol = sfSymbol
    }
    // We are using this decoder initializor to try and decode this object to map the values from the coding keys to each value inside of itself - AF
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
                    self.title = try container.decodeIfPresent(String.self, forKey: .title)
                    self.content = try container.decodeIfPresent(String.self, forKey: .content)
                    //self.image = try container.decodeIfPresent(String.self, forKey: .image)
                    self.sfSymbol = try container.decodeIfPresent(String.self, forKey: .sfSymbol)
        } catch {
            print(error)
        }
        
    }
}
