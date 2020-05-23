//
//  Token.swift
//  backyard
//
//  Created by Nik Burnt on 5/15/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Authentication
import FluentMySQL


// MARK: - Token

struct Token: MySQLModel {

    // MARK: - MySQLModel

    static var entity: String = "tokens"

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case token
    }


    // MARK: - Public Variables

    var id: Int?

    var userId: Int
    var token: String

}
