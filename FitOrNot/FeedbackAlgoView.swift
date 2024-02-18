//
//  FeedbackAlgoView.swift
//  FitOrNot
//
//  Created by Sartaj Gill  on 11/11/23.
//

import SwiftUI

struct FeedbackAlgoView: View {
    let type: NotificationType
    
    var body: some View {
        VStack {
            Text(notificationTitle())
                .font(.title)
                .padding(.bottom, 5)
                .foregroundColor(notificationTitleColor())
            
            Text(notificationText())
                .padding()
                .foregroundColor(notificationTextColor())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(notificationBackgroundColor())
        .cornerRadius(10)
        .padding(20)
        .transition(.move(edge: .top))
        .animation(.easeInOut(duration: 0.5))
        .onAppear {
            // You can add any additional logic on view appear
        }
        .onDisappear {
            // You can add any additional logic on view disappear
        }
    }
    
    private func notificationTitle() -> String {
        switch type {
        case .tooLarge:
            return "ADJUSTING PRODUCT SIZING"
        case .tooSmall:
            return "REFINING PRODUCT SIZING"
        case .perfect:
            return "OPTIMAL SIZING ACHIEVED"
        }
    }
    
    private func notificationTitleColor() -> Color {
        switch type {
        case .tooLarge:
            return .black // Change the color as needed
        case .tooSmall:
            return .black// Change the color as needed
        case .perfect:
            return .green // Change the color as needed
        }
    }
    
    private func notificationText() -> String {
        switch type {
        case .tooLarge:
            return "Your feedback is crucial as we strive to improve product sizing. Our algorithm adapts based on multiple attempts. Thank you for contributing!"
        case .tooSmall:
            return "Your feedback is essential as we refine product sizing. Our algorithm adapts based on multiple attempts. Thank you for helping us enhance our offerings!"
        case .perfect:
            return "Thank you for your feedback! Our products now achieve optimal sizing. We appreciate your valuable input."
        }
    }
    
    private func notificationTextColor() -> Color {
        switch type {
        case .tooLarge:
            return .black // Change the color as needed
        case .tooSmall:
            return .black // Change the color as needed
        case .perfect:
            return .black // Change the color as needed
        }
    }
    
    private func notificationBackgroundColor() -> Color {
        switch type {
        case .tooLarge:
            return .white // Change the color as needed
        case .tooSmall:
            return .white // Change the color as needed
        case .perfect:
            return .green // Change the color as needed
        }
    }
}

enum NotificationType {
    case tooLarge
    case tooSmall
    case perfect
}



#Preview {
    FeedbackAlgoView(type: .tooLarge)
}

