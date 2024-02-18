//
//  Home.swift
//  FitOrNot
//
//  Created by Ali Farhat on 9/20/23.
//

import SwiftUI




struct Home: View {
    
    // Saved to local device storage that when a user has experienced the Onboarding the will not be displayed the Onboarding again Line 16 - AF
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var selectedTab = 0 // Pick which Tab we would like
    //@State var age: String = ""
    @State var gender: String = ""
    @State var neck: String = ""
    @State var shoulder: String = ""
    @State var sleeve: String = ""
    @State var chest: String = ""
    @State var waist: String = ""
    @State var hip: String = ""
    @State var inseam: String = ""
    @State var thigh: String = ""

        
var body: some View {
    
        TabView (selection: $selectedTab){
            
            // Each TabItem represents a tab in your navigation bar
            // Lines 40 - 87 Ali Farhat
            // Home View
            Main()
            // Tab Item with the home icon when selected will display the Main view - AF
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .background{
                    Color(red: 0.89, green: 0.89, blue: 0.89)}
                .ignoresSafeArea()
                .tag(0)
            
            
            // Instructions View
            Instructions(ID: "4FjGmSsBr0o")
            // Tab Item with the measurement icon when selected will display the Measure view - AF
                .tabItem {
                    Label("Measure", systemImage: "lines.measurement.horizontal")
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background{
                    Color(red: 0.89, green: 0.89, blue: 0.89)}
                .ignoresSafeArea()
                .tag(1)
                .onTapGesture {
                    // open camera
                }
            
             
            // Profile View
            Profile(/*age: $age,*/ gender: $gender, neck: $neck, shoulder: $shoulder, sleeve: $sleeve, chest: $chest, waist: $waist, hips:$hip, inseam: $inseam, thigh: $thigh)
            // Tab Item with the person icon when selected will display the Profile view - AF
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                        .padding(.top, 10)
                }
                .tag(2)
            
            // Brands View
            Brands()
            // Tab Item with the store icon when selected will display the Brands view - AF
                .tabItem {
                    Label("Brands", systemImage: "storefront.fill")
                        .foregroundColor(.yellow)
                        .padding(.top, 10)
                }
                .tag(3)

        }
    // Displays the Onboarding and its content plist to cover the home screen until the user has navigated through the whole experience and is dismissed when finished Lines 89 - 96 - AF
        .fullScreenCover(isPresented: .constant(!hasSeenOnboarding), content: {
            let plistManager = PlistManagerImpl()
            let onboardingContentManager = OnboardingContentManagerImpl(manager: plistManager)
            
            OnboardingScreenView(manager: onboardingContentManager){
                hasSeenOnboarding = true
            }
        })
    // Change the tab bar color to match the overall scheme of a black bar with icons that are displayed in light gray when not in use, but a blue when selected to make sure users know  Lines 98 - 107 - AF
        .onAppear() {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor.black
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().isOpaque = true
            UITabBar.appearance().backgroundColor = UIColor.black
            UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
            
        }
    // Hide the back button Lines 109 - 112 - AF
        .navigationBarBackButtonHidden(true) // 1
        .ignoresSafeArea()
        .preferredColorScheme(.light)
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

