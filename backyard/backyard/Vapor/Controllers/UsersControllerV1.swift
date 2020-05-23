//
//  UsersControllerV1.swift
//  backyard
//
//  Created by Nik Burnt on 5/17/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Crypto
import Vapor


// MARK: - UsersController

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
        let authenticatetRoute = usersRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)

        // UsersActions

        let currentUserRoute = authenticatetRoute.grouped("current")
        currentUserRoute.get(use: getCurrentHandler)
        currentUserRoute.post(User.UpdateData.self, use: updateCurrentHandler)
        currentUserRoute.post(User.ChangePasswordData.self, at: "change-password", use: updateCurrentPasswordHandler)
        currentUserRoute.post(User.ResetPasswordData.self, at: "reset-password", use: resetCurrentPasswordHandler)
        currentUserRoute.post("upload-avatar", use: addAvatarHandler)

        usersRoute.post(User.RegistrationData.self, at: "register", use: registerHandler)
    }


    // MARK: - Private Methods

    private func loginHandler(_ request: Request) throws -> Future<Token.Public> {
        let user = try request.requireAuthenticated(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: request).public
    }

    private func getCurrentHandler(_ request: Request) throws -> Future<User.Public> {
        guard let loggedInUser = try request.authenticated(User.self) else {
            throw Abort(.unauthorized)
        }
        return request.future(loggedInUser.public)
    }

    private func updateCurrentHandler(_ request: Request, data: User.UpdateData) throws -> Future<User.Public> {
        guard let loggedInUser = try request.authenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        return loggedInUser.updated(with: data).update(on: request).public
    }

    private func updateCurrentPasswordHandler(_ request: Request, data: User.ChangePasswordData) throws -> Future<User.Public> {
        guard let loggedInUser = try request.authenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        try data.validate()

        return try loggedInUser.updated(with: data).update(on: request).public
    }

    private func resetCurrentPasswordHandler(_ request: Request, data: User.ResetPasswordData) throws -> Future<User.Public> {
        guard let loggedInUser = try request.authenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        try data.validate()

        let newPassword = PasswordGenerator.generatePassword()
        let dataWithNewPassword = User.ResetPasswordData(email: data.email, newPassword: newPassword)
        return try loggedInUser
            .updated(with: dataWithNewPassword)
            .update(on: request)
            .then { _ in self.mailingService.send(resetPassword: newPassword, to: data.email) }
            .map { _ in loggedInUser.public }
    }


    private func registerHandler(_ request: Request, data: User.RegistrationData) throws -> Future<Token.Public> {
        guard try request.authenticated(User.self) == nil else {
            throw Abort(.badRequest, reason: "User should not be logged in to register.")
        }

        try data.validate()

        let user = try User(with: data)
        return user
            .save(on: request)
            .thenThrowing { user -> Token in
                try request.authenticate(user)
                let token = try Token.generate(for: user)
                return token
            }
            .then { $0.save(on: request).public }
    }


    private func addAvatarHandler(_ request: Request) throws -> Future<User.Public> {
        guard let loggedInUser = try request.authenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        return request.http.body
            .consumeData(on: request)
            .thenThrowing { try loggedInUser.updated(with: $0) }
            .then { $0.save(on: request) }
            .public
    }

}
