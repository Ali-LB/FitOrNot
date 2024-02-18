//
//  LiDARScanner.swift
//  FitOrNot
//
//  Created by Alfred Carra on 11/5/23.
//

import SwiftUI
import RealityKit
import ARKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore


// The following 400~ lines of code were written by Alfred Carra


struct ARButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .padding()
            .frame(width: 200, height:50, alignment: .center)
            .font(Font.custom("Koulen", size: 18))
            .foregroundColor(Color(red: 0.13, green: 0.51, blue: 0.87))
            .background(Color(red: 0.89, green: 0.89, blue: 0.89))
            .cornerRadius(50)
            .overlay(RoundedRectangle(cornerRadius: 50)
            .inset(by: 0.50)
            .stroke(Color(red: 0.13, green: 0.13, blue: 0.13)))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
        
        
    }
}

// create enum that stores number value for measurements
enum BodyPart: String, CaseIterable {
    
    case chest = "chest"
    case waist = "waist"
    case hip = "hips"
    
    var numberOfAnchors: Int {
        switch self {
            
        case .chest:
            return 6
        case .waist:
            return 6
        case .hip:
            return 6
            
        }
    }
}

// reticle for LiDAR View Anchor placements
struct centerCircle: View{
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .opacity(1)
            .frame(width: 8, height: 8)
        Circle()
            .fill(Color.black)
            .opacity(1)
            .frame(width: 4, height : 4)
    }
    
}

struct LiDARContentView: View{
    @EnvironmentObject  var sessionManager: ARSessionManager
    @State private var cameraPD : Float = 0.0 // distance from camera
    @State private var bodyPD : Float = 0.0 //body point distance to between parts
    @State private var bodyPP:  [SIMD3<Float>] = [] // array for predefined points
    @State private var chosenBodyPt: BodyPart? = nil // defines the chosen body part for
    @State private var isMeasureing: Bool = false // checks if the user is measuring or not
    @State private var anchorPtsPlaced: Int = 0 // keeps track of the amount of anchor points placed.
    @State private var myError: MyCustomError? = nil // link for custom error injection
    
    var body: some View {
        GeometryReader { geometry in // allows for objects to be sized according to screen.
            ZStack{
                ARViewController(cameraPD: $cameraPD, bodyPD: $bodyPD,bodyPP: $bodyPP,chosenBodyPt: $chosenBodyPt, isMeasureing: $isMeasureing).edgesIgnoringSafeArea(.all)
                    .id(sessionManager.sessionID)
                centerCircle().position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                VStack{
                    Spacer()
                    Text("Measured Distance:  \(String (format: "%.1f", sessionManager.bodyPD)) inches")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.top,geometry.size.height * 0.72)
                    
                    VStack{
                        if !isMeasureing {
                            ForEach(BodyPart.allCases, id: \.self) { bodyPart in
                                Button(action: {
                                    self.chosenBodyPt = bodyPart
                                    self.isMeasureing = true
                                    self.anchorPtsPlaced = 0
                                }) {
                                    Text(bodyPart.rawValue)
                                }.buttonStyle(ARButtonStyle())
                            }
                        }
                        
                        // handles state for when user is measuring and is not finished yet.
                        if isMeasureing && anchorPtsPlaced < chosenBodyPt?.numberOfAnchors ?? 0 {
                            Button("Add Anchor"){
                                do {
                                    try sessionManager.dropAnchor()
                                    anchorPtsPlaced += 1
                                } catch { print("Error occurred: \(error.localizedDescription)")
                                    sessionManager.error = error as? MyCustomError }
                                
                            }.buttonStyle(ARButtonStyle())
                            
                            Button("Remove Last"){
                                do {
                                    try sessionManager.pickUpAnchor()
                                    anchorPtsPlaced = max(0, anchorPtsPlaced - 1)
                                    
                                } catch{ sessionManager.error = error as? MyCustomError}
                                
                                
                            }.buttonStyle(ARButtonStyle())
                            
                            Button("Reset All") {
                                sessionManager.removeAllAnchors()
                                isMeasureing = false
                                anchorPtsPlaced = 0
                            }.buttonStyle(ARButtonStyle())
                            
                        }
                        
                        // handles state for when user is finished measuring a body part
                        if isMeasureing && anchorPtsPlaced == chosenBodyPt?.numberOfAnchors {
                            
                            Button("Send Meausrements") {
                                // send measurements to database
                                
                                self.sendToFirebase()
                                sessionManager.removeAllAnchors()
                                isMeasureing = false
                                chosenBodyPt = nil
                                
                                anchorPtsPlaced = 0
                            }.buttonStyle(ARButtonStyle())
                            
                            Button("Reset All") {
                                sessionManager.removeAllAnchors()
                                isMeasureing = false
                                chosenBodyPt = nil
                                anchorPtsPlaced = 0
                            }.buttonStyle(ARButtonStyle())
                        }
                    }.padding(.bottom,geometry.size.height * 0.08)
                }
            }.alert(item: $sessionManager.error){ error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK"))) // error handling for AR View.
            }
        }
    }
    
    // create mapping for database
    let bodyPartMap: [BodyPart: String ] = [
        .chest: "chest",
        .waist: "waist",
        .hip: "hip"
    ]
    
    
    // method send measurements to firebase
    func sendToFirebase() {
        //debug statement firebase auth syncrocity
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in!")
            return
        }
        
        //debug statement chosen body part 
        guard let selectedbodyPt = self.chosenBodyPt?.rawValue else {
            print ("No body part selected.")
            return
        }
        
        //instance variable
        let db = Firestore.firestore()
        // loop that injects measurement into specific firebase field based on bodypartmap
        for (bodyPart, firebaseField) in bodyPartMap {
            if bodyPart.rawValue == selectedbodyPt {
                let measurementNum: [String: Float] = [
                    firebaseField : sessionManager.bodyPD
                ]
                
                // send data to firebase measurement collection
                db.collection("users").document(userID).setData(measurementNum, merge: true, completion: { error in
                    if let error = error {
                        print("Error updating user data: \(error.localizedDescription)")
                    } else {
                        print("User data updated successfully.")
                    }
                })
            }
        }
    }
}

// this class is how we will be manipulating the objects and referencing them in the AR View.
class ARSessionManager: ObservableObject {
    
    weak var arView: ARView?
    
    @Published var cameraPD : Float = 0.0 // distance from camera
    @Published var bodyPD : Float = 0.0 //body point distance to between parts
    @Published var bodyPP:  [SIMD3<Float>] = [] // array for predefined points
    @Published var chosenBodyPt: BodyPart? = nil // defines the chosen body part for
    @Published var isMeasureing: Bool = false // checks if the user is measuring or not
    @Published var anchorPtsPlaced: Int = 0 // keeps track of the amount of anchor points placed.
    
    @Published var error: MyCustomError? = nil
    @Published var sessionID = UUID()
    
    //resets unique session ID
    func restartARView() {
        sessionID = UUID()
    }
    
    //setup ARView
    func setupARView(_ view: ARView ){
        self.arView = view
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        view.session.run(config)
    }
    
    // this function allows a user to drop an anchor for measurement.
    func dropAnchor() throws {
        guard let arView = self.arView else { throw MyCustomError.anchorDidntPlace }
        let centerScreen = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
      
        if let raycastQuery = arView.makeRaycastQuery(from: centerScreen, allowing: .estimatedPlane, alignment: .any ), let result = arView.session.raycast(raycastQuery).first {
            
            let anchor = ARAnchor(transform: result.worldTransform)
            arView.session.add(anchor: anchor)
            
            let point = SIMD3<Float>(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z )
            self.bodyPP.append(point)
             
            // trigger the update at the publsihed variable that holds the body distance.
            self.bodyPD = calPathDistance(points: self.bodyPP)
            
            
            // debug print statement
            for (index, point) in bodyPP.enumerated(){
                print("point is \(index): \(point) and distance is \(bodyPD) ")
            }
        } else { throw MyCustomError.anchorDidntPlace}
    }
    
    // simple point distance calculation which adds the sum of the distance for each segment.
    private func calPathDistance(points: [SIMD3<Float>]) -> Float {
        guard points.count > 1 else { return 0.0 }
        
        var totalDist: Float = 0.0
        for i in 1..<points.count {
            let segDist = simd_distance(points[i], points[i - 1])
            totalDist += segDist // appending to total distance
        }
        let totalDistCm = totalDist * 100 // conversion to cm
        let roundedTotalDistCm = String(format: "%.1f", totalDistCm) //cm rounded
        let totalDistIn = totalDist * 39.3701 // inches
        let roundedTotalDistIn = String(format: "%.1f", totalDistIn) // inches rounded
        return Float(roundedTotalDistIn) ?? totalDistIn
    }
    
    // this function allows for the most recently placed anchor to be picked up.
    func pickUpAnchor() throws {
        guard let lastAnchor = arView?.session.currentFrame?.anchors.last else { throw MyCustomError.anchorDidntPickup  }
        // remove anchor from screen
        arView?.session.remove(anchor: lastAnchor)
        // remove last appended point to the point array
        if !bodyPP.isEmpty {
            bodyPP.removeLast()
        }
        //update distance
        bodyPD = calPathDistance(points: bodyPP)
        
        //debug print statement
        for (index, point) in bodyPP.enumerated(){
            print("point is \(index): \(point) and distance is \(bodyPD) ")
        }
    }
    
    // this function removes all anchors on the AR View.
    func removeAllAnchors() {
        if let anchors = arView?.session.currentFrame?.anchors {
            for anchor in anchors {
                arView?.session.remove(anchor: anchor)
            }
            bodyPP.removeAll()
            bodyPD = 0.0
        }
    }
}

// this struct is what determines the conditions for the AR Scanner.
struct ARViewController : UIViewRepresentable {
    @EnvironmentObject var arSessionManager: ARSessionManager
    @Binding var cameraPD: Float
    @Binding var bodyPD: Float
    @Binding var bodyPP: [SIMD3<Float>] // array of body points
    @Binding var chosenBodyPt: BodyPart?
    @Binding var isMeasureing: Bool
    
    func makeUIView(context: Context) -> some UIView{
        
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration() // specific config for utilizing LiDAR
        config.environmentTexturing = .automatic // throws the mesh over the AR View so we can access it
        
        arView.session.delegate = context.coordinator
        arView.session.run(config)
    
        arSessionManager.setupARView(arView)
        
        return arView
    }
    
    // conformance for UIView Representable
    func updateUIView(_ uiView: UIViewType, context: Context) {
    
    }
    // method so we can access the coordinator class.
    func makeCoordinator() -> ARSessionDelegateCoordinator {
        return ARSessionDelegateCoordinator(sessionManager: arSessionManager)
    }
}

class ARSessionDelegateCoordinator : NSObject, ARSessionDelegate {
    
    var sessionManager: ARSessionManager // create  and access from outside.
    init(sessionManager: ARSessionManager) {
        self.sessionManager = sessionManager
    }

    // this configures the actual AR Session. allowing for anchors to be added to the view.
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
        // handle new anchors
            for anchor in anchors {
                
                let sphere = ModelEntity(mesh: .generateSphere(radius: 0.02))
                let anchorObj = AnchorEntity(anchor: anchor)
                anchorObj.addChild(sphere)
                sessionManager.arView?.scene.addAnchor(anchorObj)
            }
        }
}

// create custom error handling class for AR Anchors
enum MyCustomError: Error, LocalizedError, Identifiable {
    
    case anchorDidntPlace
    case anchorDidntPickup
    
    var errorDescription: String? {
        switch self {
        case .anchorDidntPlace:
            return "Anchor was not placed please try again."
        case .anchorDidntPickup:
            return "Anchor was not removed please try again."
        }
    }
    // confrom to identifyable error
    var id: String {
        return errorDescription ?? "Error Unknown"
        
    }
    
}
// custom binding for optional values and booleans
extension Binding where Value == Bool {
    
    init<T>(value:Binding<T?>) {
        
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}


