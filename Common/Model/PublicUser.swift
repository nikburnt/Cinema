//
//  PublicUser.swift
//  
//
//  Created by Nik Burnt on 6/10/20.
//

import Foundation


// MARK: - UserRole

enum UserRole: Int, Codable {
    case customer
    case staff
}


// MARK: - PublicUser

struct PublicUser: Codable {

    var role: UserRole
    
    var email: String?
    var birthday: Date?

    var firstName: String?
    var lastName: String?

    var avatar: String?

    // MARK: - Codable Enum

    enum CodingKeys: String, CodingKey {
        case role
        case birthday
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}
