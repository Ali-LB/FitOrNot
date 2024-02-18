//
//  User.swift
//  FitOrNot
//
//  Created by Sartaj Gill  on 9/27/23.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    //let fullname: String
    var firstName: String?
    var lastName: String?
    let email: String
    var dateOfBirth: Date?
    //var age: Int?
    var gender: String?
    var neck: Float?
    var shoulder: Float?
    var sleeve: Float?
    var chest: Float?
    var waist: Float?
    var hip: Float?
    var inseam: Float?
    var thigh: Float?
    var isAdmin: Bool?
    
    var initials: String {
            if let firstLetterOfFirstName = firstName?.prefix(1),
               let firstLetterOfLastName = lastName?.prefix(1) {
                return "\(firstLetterOfFirstName)\(firstLetterOfLastName)"
            }
            return ""
        }
    

    
}

extension User{
    static var Mock_user = User(id: NSUUID().uuidString, /*fullname: "Sartaj Gill",*/ firstName: "Sartaj", lastName:"Gill", email: "gill@gmail.com", gender: "Male")
}
