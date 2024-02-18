//
//  ViewExtensions.swift
//  FitOrNot
//
//  Created by Sartaj Gill  on 10/7/23.
//

import SwiftUI

extension View{
    func getRootViewController() -> UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
