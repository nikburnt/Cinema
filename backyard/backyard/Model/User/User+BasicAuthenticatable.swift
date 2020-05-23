//
//  User+BasicAuthenticatable.swift
//  backyard
//
//  Created by Nik Burnt on 5/17/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Authentication


// MARK: - User+BasicAuthenticatable

extension User: BasicAuthenticatable {

    // MARK: - BasicAuthenticatable

    static let usernameKey: UsernameKey = \.email
    static let passwordKey: PasswordKey = \.password

}
