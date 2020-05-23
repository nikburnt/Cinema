//
//  Token+Public.swift
//  backyard
//
//  Created by Nik Burnt on 5/22/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - Token+Public

extension Token {

    // MARK: - Public Structure

    struct Public: Content {
        var token: String
    }


    // MARK: - Public Variables

    var `public`: Public { Public(token: token) }

}


// MARK: - Future+User+Public

extension EventLoopFuture where T == Token {

    // MARK: - Public Variables

    var `public`: Future<Token.Public> { map(to: Token.Public.self) { $0.public } }

}
