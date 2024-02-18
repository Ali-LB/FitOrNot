//
//  OnboardingContentManager.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/25/23.
//
// Fully created this page - Ali Farhat
import Foundation

protocol OnboardingContentManager {
    // A getter was used to not allow anyone to change it outside of its scope - AF
    var limit: Int { get }
    var items: [OnboardingItem] { get }
    // Initializor was used to unit test this for every class takes on this protocol to use any object of plist manager making it reusable - AF
    init(manager: PlistManager)
}
// Final was used so that no other class can subclass this class - AF
// Class implemented to convert a plist to an array of onboarding items - AF
final class OnboardingContentManagerImpl: OnboardingContentManager {
    
    // Gets the number of items in the array and subtracts it by one to get the index of the last item - AF
    var limit: Int {
        items.count - 1
    }
    
    // Property of our array of items going to hold our items -AF
    var items: [OnboardingItem]
    
    // initialize this class to set our items and array with the plist manager and convert it - AF
    init(manager: PlistManager) {
        self.items = manager.convert(plist: "OnboardingContent")
    }
    
    
}
