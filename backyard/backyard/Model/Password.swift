//
//  Password.swift
//  backyard
//
//  Created by Nik Burnt on 5/15/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import FluentMySQL


// MARK: - User

struct Password: MySQLModel {

    // MARK: - MySQLModel

    static var entity: String = "passwords"

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case hash
    }


    // MARK: - Public Variables

    var id: Int?

    var userId: Int
    var hash: String

}
