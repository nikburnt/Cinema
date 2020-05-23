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

    // MARK: - Public Structure

    struct Public: Content {
        var email: String?
        var birthday: Date?

        var firstName: String?
        var lastName: String?

        var avatar: String?
    }


    // MARK: - Public Variables

    var `public`: User.Public { Public(email: email, birthday: birthday, firstName: firstName, lastName: lastName, avatar: avatar) }

}


// MARK: - Future+User+Public

extension EventLoopFuture where T == User {

    // MARK: - Public Variables

    var `public`: Future<User.Public> { map(to: User.Public.self) { $0.public } }

}


extension EventLoopFuture where T == [User] {

    // MARK: - Public Variables

    var `public`: Future<[User.Public]> { map(to: [User.Public].self) { $0.compactMap { $0.public } } }

}
