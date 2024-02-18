//
//  PlistManager.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/25/23.
//
// Fully crated this page - Ali Farhat
import Foundation
// Protocol to pull any plist from string name as an Onboarding item converting it - AF
protocol PlistManager {
    func convert(plist filename: String) -> [OnboardingItem]
}

// Function convert to convert the item in the plist - AF
struct PlistManagerImpl: PlistManager {
    func convert(plist filename: String) -> [OnboardingItem] {
        // A guard statement if anything fails we want to return an empty array and chain it all and return - AF
        guard let url = Bundle.main.url(forResource: filename, withExtension: "plist"),
                let data = try? Data(contentsOf: url),
              let items = try? PropertyListDecoder().decode([OnboardingItem].self, from: data) else{
            return []
        }
        // If passing it will return the items that was decoded into an array to our Onboarding object - AF
        return items
    }
}
