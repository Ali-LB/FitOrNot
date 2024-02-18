//
//  Instructions.swift
//  FitOrNot
//
//  Created by Alfred Carra on 9/26/23.
//

import SwiftUI
import RealityKit
import ARKit
import AVKit
import AVFoundation
import WebKit


// the following 150 lines of code were written by alfred carra
// check if device supports LiDAR
func supportsLiDAR() -> Bool{
    if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification){
        return true
    }
    return false
}

struct Instructions : View {
    var arSessionManager = ARSessionManager()
    let ID: String
    
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView {
                    VStack{
                        Spacer()
                            .frame(height:150)
                        Text("Instructions")
                            .font(Font.custom("Koulen", size: 40))
                            .foregroundColor(.black)
                            .padding(.top)
                            .bold()
                            .offset(y:-100)
            
                        // case to cover supported lidar-- displays all instructions adn instructional video.
                        if supportsLiDAR(){

                            Text("1. Grab an assistant to help measure you")
                                .font(Font.custom("Koulen", size: 21))
                                .foregroundColor(.black)
                                .padding(.bottom,5)
                            
                            Text("2. Remove any loose or baggy clothing")
                                .font(Font.custom("Koulen", size: 21))
                                .foregroundColor(.black)
                                .padding(.bottom, 5)
                            
                            
                            Text("3. Stand in an open and well lit area")
                                .font(Font.custom("Koulen", size: 21))
                                .foregroundColor(.black)
                                .padding(.bottom,20)
                            
                            NavigationLink(destination: LiDARContentView().environmentObject(arSessionManager)) {
                                Text("Get Started")
                                    .frame(width: 244, height:70, alignment: .center)
                                    .font(Font.custom("Koulen", size: 30))
                                    .foregroundColor(.white)
                                    .background(Color(red: 0.13, green: 0.51, blue: 0.87))
                                    .cornerRadius(50)
                                    .offset(y:-10)
                                    .padding(.all,15)
                            }
                            
                            // this embeds the youtube video thumbnail
                            YTVView(ID: "4FjGmSsBr0o")
                                .frame(width: 350 , height: 170)
                                .cornerRadius(12)
                                .padding(.horizontal,24)
                            
                        }
                        else {
                            NavigationLink(destination: ManualMeasure()){
                                
                                Text("Add Measurements Manually in Profile!")
                                    .frame(width: 244, height:70, alignment:
                                            .center)
                                    .font(Font.custom("Koulen", size: 30))
                                    .foregroundColor(.white)
                                    .background(Color(red: 0.13, green: 0.51, blue: 0.87))
                                    .cornerRadius(50)
                                    .offset(y:-10)
                                    .padding()
                            }
                        }
                    }// end of vstack
                }
            }// end of Zstack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color(red: 0.89, green: 0.89, blue: 0.89)}
            .ignoresSafeArea()
            //Force Light Mode
            .preferredColorScheme(.light)
            .padding(.vertical, 20)
        }// end of navigation view
    }
    // end of body
}// end of instructions view

struct YTVView: View {
    let ID: String
    var body: some View {
        PlayVideoView(vID: ID)
            .frame(width:350)
    }
}

// view that holds the Webkid embed.
struct PlayVideoView: UIViewRepresentable {
    
    // video ID
    var vID: String
    
    // display UI view.
    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    }
    
    // conform to uiViewRepresentable
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(vID)") else {return}
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}

//#Preview {
//    Instructions()
//}

