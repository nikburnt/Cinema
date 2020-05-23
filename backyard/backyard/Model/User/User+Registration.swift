//
//  User+Registration.swift
//  backyard
//
//  Created by Nik Burnt on 5/22/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Crypto
import Vapor


// MARK: - User+Registration

extension User {

    // MARK: - Public Structures

    struct RegistrationData: Content, Validatable, Reflectable {

        // MARK: - Public Variables

        let email: String
        let password: String


        // MARK: - Validatable

        static func validations() throws -> Validations<RegistrationData> {
            var validations = Validations(RegistrationData.self)
            try validations.add(\.email, .email)
            validations.add("password is strong enough") { model in
                guard model.password.isStrongEnoughPassword else {
                    throw BasicValidationError("password isn't strong enough for this service")
                }
            }
            return validations
        }

    }


    // MARK: - Lifecycle

    init(with data: RegistrationData) throws {
        let passwordHash = try BCrypt.hash(data.password)
        self.init(role: .customer, email: data.email, password: passwordHash)
    }

}
