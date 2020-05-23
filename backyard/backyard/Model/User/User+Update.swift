//
//  User+Update.swift
//  backyard
//
//  Created by Nik Burnt on 5/22/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - User+Update

extension User {

    // MARK: - Public Structures

    struct UpdateData: Content {

        // MARK: - Public Variables

        let birthday: Date?
        let firstName: String?
        let lastName: String?

    }


    // MARK: - Public Methods

    func updated(with data: UpdateData) -> User {
        var copy = self
        copy.firstName = data.firstName
        copy.lastName = data.lastName
        copy.birthday = data.birthday
        return copy
    }

}
