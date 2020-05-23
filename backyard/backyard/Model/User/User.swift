//
//  User.swift
//  backyard
//
//  Created by Nik Burnt on 5/13/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import FluentMySQL


// MARK: - User

struct User: MySQLModel {

    // MARK: - Public Enums

    enum Role: Int, Codable {
        case customer
        case staff
    }


    // MARK: - Codable Enum

    enum CodingKeys: String, CodingKey {
        case id
        case role
        case birthday
        case email
        case password
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }


    // MARK: - MySQLModel

    static var entity: String = "users"


    // MARK: - Public Variables

    var id: Int?

    var role: Role

    var email: String
    var password: String

    var birthday: Date?
    var firstName: String?
    var lastName: String?

    var avatar: String?

}
