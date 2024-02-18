//
//  Test.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/9/23.
//

import SwiftUI

struct Test: View {
    @State var color : String = ""
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [.white],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
            VStack{
                Ellipse()
                    .foregroundColor(.clear)
                    .frame(height: 120)
                    .background(
                        Image("t-logo")
                            .resizable()
                            .frame(width: 70, height: 70)
                    )
                    .frame(width:90, height:90)
                                        .background(Color.white)
                                        .cornerRadius(50)
                                        .padding(5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .stroke(style:
                                                            StrokeStyle(lineWidth: 3, lineCap: .round ,dash: [7])
                                                       )
                                                .foregroundColor(Color.black)
                                        )
                
                Text("Size Recommendation: " /*+ shirt*/)
                    .font(Font.custom("Koulen", size: 30))
            }
            .offset(y:10)
        }
    }
}

struct Glow: ViewModifier {
    func body(content: Content) -> some View {
        ZStack{
            content.blur(radius: 15)
            content
        }
    }
}

extension View {
    func glow() -> some View  {
        modifier(Glow())
    }
}


#Preview {
    Test()
}
