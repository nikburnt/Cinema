//
//  User+TokenAuthenticatable.swift
//  backyard
//
//  Created by Nik Burnt on 5/17/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Authentication


// MARK: - User+TokenAuthenticatable

extension User: TokenAuthenticatable {

    // MARK: - TokenAuthenticatable

    typealias TokenType = Token

}
