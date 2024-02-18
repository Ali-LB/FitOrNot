//
//  OnboardingScreenView.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/25/23.
//
// Fully created this page - Ali Farhat
import SwiftUI

struct OnboardingScreenView: View {
    
    // Importing the protocol to get elements for Onboarding - AF
    let manager: OnboardingContentManager
    let handler: OnboardingGetStartedAction
    @State private var selected = 0
    init(manager: OnboardingContentManager,
                  handler : @escaping OnboardingGetStartedAction) {
        self.manager =  manager
        self.handler = handler
    }
    
    // Each view is displaying each plist listed in the Onboarding Content when users are swiping from one view to the next taking using the Onboarding manager - AF
    var body: some View {
        TabView(selection: $selected) {
            ForEach(manager.items.indices) { index in
                OnboardingView(item: manager.items[index], limit: manager.limit, index: $selected, handler: handler)
            }
        }
        // Tab View Properties (Background color set, ignore safe areas of device screen, Page Tab is set, Display mode is set to always to display until user dismisses - AF
        .background{
            Color(red: 0.89, green: 0.89, blue: 0.89)}
        .ignoresSafeArea()
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingScreenView(manager: OnboardingContentManagerImpl(manager: PlistManagerImpl())) {}
}
