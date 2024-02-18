//
//  ProfileRowView.swift
//  FitOrNot
//
//  Created by Sartaj Gill  on 9/27/23.
//

import SwiftUI

struct ProfileRowView: View {
    let ImageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing:12){
            Image(systemName: ImageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    ProfileRowView(ImageName: "gear", title:"Version", tintColor: Color(.systemGray))
}
