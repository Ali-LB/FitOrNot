//
//  Topbar.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/10/23.
//

import SwiftUI

struct Topbar: View {
    var body: some View {
        HStack(){
                Button(action: {
                    // Action for first button
                }) {
                    Image(systemName: "plus")
                }
                Text("FitOrNot")
                    .font(.title)
                Button(action: {
                    // Action for first button
                }) {
                    Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    Topbar()
}
