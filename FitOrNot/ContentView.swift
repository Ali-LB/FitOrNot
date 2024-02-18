//
//  ContentView.swift
//  FitOrNot
//
//  Created by Alfred Carra on 9/18/23.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {

        Group{
            if viewModel.userSession != nil {
                Home()
            } else{
                LaunchView()
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
#endif
