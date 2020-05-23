//
//  Token+Generation.swift
//  backyard
//
//  Created by Nik Burnt on 5/17/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Crypto


// MARK: - Token+Generation

extension Token {

    static func generate(for user: User) throws -> Token {
        let token = try CryptoRandom().generateData(count: 16)
        let result = try Token(userId: user.requireID(), token: token.base64EncodedString())
        return result
    }

}
