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

    // MARK: - Public Variables

    var `public`: PublicToken { PublicToken(token: token, expirationDate: expirationDate ?? Date(timeIntervalSince1970: 0)) }

}

extension PublicToken: Content { }


// MARK: - Future+User+Public

extension EventLoopFuture where T == Token {

    // MARK: - Public Variables

    var `public`: Future<PublicToken> { map(to: PublicToken.self) { $0.public } }

}
