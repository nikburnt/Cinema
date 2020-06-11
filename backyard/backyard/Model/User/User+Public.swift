//
//  User+Public.swift
//  backyard
//
//  Created by Nik Burnt on 5/17/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - User+Public

extension User {

    // MARK: - Public Variables

    var `public`: PublicUser { PublicUser(role: role, email: email, birthday: birthday, firstName: firstName, lastName: lastName, avatar: avatar) }

}

extension PublicUser: Content { }


// MARK: - Future+User+Public

extension EventLoopFuture where T == User {

    // MARK: - Public Variables

    var `public`: Future<PublicUser> { map(to: PublicUser.self) { $0.public } }

}


extension EventLoopFuture where T == [User] {

    // MARK: - Public Variables

    var `public`: Future<[PublicUser]> { map(to: [PublicUser].self) { $0.compactMap { $0.public } } }

}
