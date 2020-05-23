//
//  Token+BearerAuthenticatable.swift
//  backyard
//
//  Created by Nik Burnt on 5/17/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Authentication


// MARK: - Token+BearerAuthenticatable

extension Token: BearerAuthenticatable {

    // MARK: - BearerAuthenticatable

    static let tokenKey: TokenKey = \.token

}
