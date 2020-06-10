//
//  UsersControllerV1.swift
//  backyard
//
//  Created by Nik Burnt on 5/17/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Authentication
import Crypto
import Vapor


// MARK: - UsersControllerErrors

enum UsersControllerErrors: Error {
    case tokenCreationError
}


// MARK: - UsersControllerV1

struct UsersControllerV1: RouteCollection {

    // MARK: - Public Variables

    let mailingService: MailingService


    // MARK: - RouteCollection

    func boot(router: Router) throws {
        // Root Route
        let usersRoute = router.grouped("users")


        // Basic Authentication for User Log In

        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let basicAuthGroup = usersRoute.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: loginHandler)


        // Bearer Authentication for requests

        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let authenticatedRoute = usersRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)


        // Users Actions

        let currentUserRoute = authenticatedRoute.grouped("current")
        currentUserRoute.get(use: getCurrentHandler)
        currentUserRoute.put(User.UpdateData.self, use: updateCurrentHandler)
        currentUserRoute.patch(User.ChangePasswordData.self, at: "change-password", use: updateCurrentPasswordHandler)
        currentUserRoute.patch("upload-avatar", use: addAvatarHandler)

        usersRoute.post(User.RegistrationData.self, at: "register", use: registerHandler)
        usersRoute.patch(User.ResetPasswordData.self, at: "reset-password", use: resetPasswordHandler)
    }


    // MARK: - Private Methods

    private func loginHandler(_ request: Request) throws -> Future<Token.Public> {
        let user = try request.requireAuthenticated(User.self)
        let token = try Token.generate(for: user)
        return token
            .save(on: request)
            .thenThrowing { Token.find(try $0.requireID(), on: request) }
            .flatMap { $0.unwrap(or: UsersControllerErrors.tokenCreationError) }
            .public
    }

    private func getCurrentHandler(_ request: Request) throws -> Future<User.Public> {
        let loggedInUser: User = try request.requireAuthenticated()
        return request.future(loggedInUser.public)
    }

    private func updateCurrentHandler(_ request: Request, data: User.UpdateData) throws -> Future<User.Public> {
        let loggedInUser: User = try request.requireAuthenticated()
        return loggedInUser.updated(with: data).update(on: request).public
    }

    private func updateCurrentPasswordHandler(_ request: Request, data: User.ChangePasswordData) throws -> Future<User.Public> {
        try data.validate()

        let loggedInUser: User = try request.requireAuthenticated()
        return try loggedInUser.updated(with: data).update(on: request).public
    }

    // Async didnt have a first where method
    // swiftlint:disable first_where
    private func resetPasswordHandler(_ request: Request, data: User.ResetPasswordData) throws -> Future<HTTPStatus> {
        guard request.http.headers.bearerAuthorization == nil else {
            throw Abort(.forbidden, reason: "User should not be logged in to reset password.")
        }

        try data.validate()

        let newPassword = PasswordGenerator.generatePassword()
        let dataWithNewPassword = User.ResetPasswordData(email: data.email, newPassword: newPassword)
        return User.query(on: request)
            .filter(\.email, .equal, data.email)
            .first()
            .unwrap(or: Abort(.notFound, reason: "User with this email not found."))
            .map { try $0.updated(with: dataWithNewPassword) }
            .update(on: request)
            .and(mailingService.send(resetPassword: newPassword, to: data.email))
            .map { _ in .ok }
    }


    private func registerHandler(_ request: Request, data: User.RegistrationData) throws -> Future<Token.Public> {
        guard request.http.headers.bearerAuthorization == nil else {
            throw Abort(.forbidden, reason: "User should not be logged in to register.")
        }

        do {
            try data.validate()
        } catch {
            throw Abort(.expectationFailed, reason: "Password is too weak.")
        }

        let user = try User(with: data)
        return user
            .save(on: request)
            .thenThrowing { user -> Token in
                try request.authenticate(user)
                let token = try Token.generate(for: user)
                return token
            }
            .then { $0.save(on: request).public }
            .catchMap { _ in throw Abort(.conflict, reason: "User with this email already exists.") }
    }


    private func addAvatarHandler(_ request: Request) throws -> Future<User.Public> {
        let loggedInUser: User = try request.requireAuthenticated()
        return request.http.body
            .consumeData(on: request)
            .thenThrowing { try loggedInUser.updated(with: $0) }
            .then { $0.save(on: request) }
            .public
    }

}
