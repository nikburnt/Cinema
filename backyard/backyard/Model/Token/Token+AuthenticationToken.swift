//
//  Token+AuthenticationToken.swift
//  backyard
//
//  Created by Nik Burnt on 5/17/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Authentication


// MARK: - Token+Authentication.Token

extension Token: Authentication.Token {

    // MARK: - Token

    typealias UserType = User

    static let userIDKey: UserIDKey = \.userId

}
