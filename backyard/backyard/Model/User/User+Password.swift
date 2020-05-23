//
//  User+Password.swift
//  backyard
//
//  Created by Nik Burnt on 5/22/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Crypto
import Vapor


// MARK: - UserErrors

enum ChangePasswordErrors: Error {
    case wrongPassword
    case wrongEmail
}


// MARK: - User+Password

extension User {

    // MARK: - Public Structures

    struct ChangePasswordData: Content, Validatable, Reflectable {

        // MARK: - Public Variables

        let oldPassword: String
        let newPassword: String


        // MARK: - Validatable

        static func validations() throws -> Validations<ChangePasswordData> {
            var validations = Validations(ChangePasswordData.self)
            validations.add("password is strong enough") { model in
                guard model.newPassword.isStrongEnoughPassword else {
                    throw BasicValidationError("password isn't strong enough for this service")
                }
            }
            return validations
        }

    }

    struct ResetPasswordData: Content, Validatable, Reflectable {

        // MARK: - Public Variables

        let email: String
        let newPassword: String?


        // MARK: - Validatable

        static func validations() throws -> Validations<ResetPasswordData> {
            var validations = Validations(ResetPasswordData.self)
            try validations.add(\.email, .email)
            return validations
        }

    }


    // MARK: - Public Methods

    func updated(with data: ChangePasswordData) throws -> User {
        guard try BCrypt.hash(data.oldPassword) == self.password else {
            throw ChangePasswordErrors.wrongPassword
        }

        var copy = self
        let passwordHash = try BCrypt.hash(data.newPassword)
        copy.password = passwordHash
        return copy
    }

    func updated(with data: ResetPasswordData) throws -> User {
        guard let password = data.newPassword else {
            throw ChangePasswordErrors.wrongPassword
        }

        guard email == data.email else {
            throw ChangePasswordErrors.wrongEmail
        }

        var copy = self
        let passwordHash = try BCrypt.hash(password)
        copy.password = passwordHash
        return copy
    }

}
