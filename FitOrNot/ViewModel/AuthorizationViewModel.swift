//
//  AuthorizationViewModel.swift
//  FitOrNot
//
//  Created by Sartaj Gill on 9/27/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import GoogleSignIn

protocol AuthenticationFormProtocol{
    var formIsValid: Bool{get}
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: Firebase.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch{
            print("Failed to login \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String /*, fullname: String*/) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, /*fullname: fullname,*/ firstName: nil, lastName: nil, email: email, gender: nil)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
        }
    }

    func createUser(withEmail email: String,/*fullname: String,*/ firstName: String? = nil, lastName: String? = nil) async throws {
        let randomPassword = UUID().uuidString
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: randomPassword)
            self.userSession = result.user
            let user = User(id: result.user.uid, /*fullname: fullname,*/ firstName: firstName, lastName: lastName, email: email, gender: nil)
            let encodedUser = try Firestore.Encoder().encode(user)
            do{
                try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
                await fetchUser()
            }catch {
                print("Failed to collect user123: \(error.localizedDescription)")
            }
            print("Succesfully created user:")
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
        }
    }



    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch{
            print("Failed to sign out \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badURL)
        }
        try await user.delete()
        self.userSession = nil
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
        }
    }

    
    func saveMeasurements(){
        
    }
    func setUserSession(user: Firebase.User?) {
        self.userSession = user
    }
    
    func signinWithGoogle(presenting: UIViewController, completion: @escaping(Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { [self] result, error in
            guard error == nil else {
                completion(error)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  //let fullName = user.profile?.name,
                  let email = user.profile?.email,
                  let uid = user.userID
            else {
                completion(NSError(domain: "AuthenticationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to authenticate with Google."]))
                return
            }

            // Create the user document in Firestore
            Task {
                do {
                    try await createUser(withEmail: email/*,  fullname: fullName*/)
                } catch {
                    completion(error)
                    return
                }

                // Fetch the user's data from Firestore
                await fetchUser()

            
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                Auth.auth().signIn(with: credential) { result, error in
                    guard error == nil else {
                        completion(error)
                        return
                    }

                    // Set the user session
                    self.userSession = result?.user
                    completion(nil)
                    self.currentUser = User(id: uid, /*fullname: fullName,*/ firstName: nil, lastName: nil, email: email, gender: nil)
                }
            }
        }
    }

    
    func updateUser(id: String, fullname: String? = nil, firstName: String? = nil, lastName: String? = nil, dateOfBirth: Date? = nil, age: Int? = nil, gender: String? = nil, neck: Int? = nil, shoulder: Int? = nil, sleeve: Int? = nil, chest: Int? = nil, waist: Int? = nil, hip: Int? = nil, inseam: Int? = nil, thigh: Int? = nil, isAdmin: Bool? = nil) async throws {
        do {
            var userRef = Firestore.firestore().collection("users").document(id)
            
            // Fetch the existing user data
            let userDocument = try await userRef.getDocument()
            var userData = try Firestore.Decoder().decode(User.self, from: userDocument.data() ?? [:])
            
            // Update the user data if the parameters are not nil
            if let firstName = firstName { userData.firstName = firstName }
            if let lastName = lastName { userData.lastName = lastName }
            if let dateOfBirth = dateOfBirth { userData.dateOfBirth = dateOfBirth }
            //if let age = age { userData.age = age }
            if let gender = gender { userData.gender = gender }
            if let neck = neck { userData.neck = Float(neck) }
            if let shoulder = shoulder { userData.shoulder = Float(shoulder) }
            if let sleeve = sleeve { userData.sleeve = Float(sleeve) }
            if let chest = chest { userData.chest = Float(chest) }
            if let waist = waist { userData.waist = Float(waist) }
            if let hip = hip { userData.hip = Float(hip) }
            if let inseam = inseam { userData.inseam = Float(inseam) }
            if let thigh = thigh { userData.thigh = Float(thigh) }
            if let isAdmin = isAdmin { userData.isAdmin = Bool(isAdmin) }
            
            
            // Encode and update the user data in Firestore
            let encodedUser = try Firestore.Encoder().encode(userData)
            try await userRef.setData(encodedUser)
        } catch {
            print("Failed to update user: \(error.localizedDescription)")
        }
    }

    
    
}
