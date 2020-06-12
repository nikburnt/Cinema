//
//  CinemaDataProvider.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/9/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation

import PromiseKit
import Require


// MARK: - UserState

enum UserState {
    case loggedIn
    case tokenExpired
    case notLoggedIn
}


// MARK: - CinemaErrors

enum CinemaErrors: Error {
    case notLoggedIn
}


// MARK: - CinemaDataProvider

class CinemaDataProvider {

    // MARK: - Public Variables

    static var shared = CinemaDataProvider()

    var userState: UserState {
        guard let tokenExpirationDate = keychainProvider.tokenExpirationDate,
              keychainProvider.token != nil,
              keychainProvider.email != nil,
              keychainProvider.password != nil else {
            return .notLoggedIn
        }

        let result: UserState = tokenExpirationDate < Date() ? .tokenExpired : .loggedIn
        return result
    }


    // MARK: - Private Varaibles

    private let networkProvider: CinemaNetworkingV1
    private let keychainProvider: CinemaKeychain


    // MARK: - Lifecycle

    private init() {
        self.networkProvider = CinemaNetworkingV1()
        self.keychainProvider = CinemaKeychain()
    }


    // MARK: - Authentication

    func refreshToken() -> Promise<Void> {
        userState == .tokenExpired ? login(email: keychainProvider.email.require(), password: keychainProvider.password.require())
                                   : .init(error: CinemaErrors.notLoggedIn)
    }

    func login(email: String, password: String) -> Promise<Void> {
        networkProvider
            .login(email: email, password: password)
            .map { response -> Void in
                self.keychainProvider.email = email
                self.keychainProvider.password = password
                self.keychainProvider.token = response.token
                self.keychainProvider.tokenExpirationDate = response.expirationDate
                return ()
            }
    }

    func register(email: String, password: String) -> Promise<Void> {
        networkProvider
            .register(email: email, password: password)
            .map { response -> Void in
                self.keychainProvider.email = email
                self.keychainProvider.password = password
                self.keychainProvider.token = response.token
                self.keychainProvider.tokenExpirationDate = response.expirationDate
                return ()
            }
    }

    func resetPassword(email: String) -> Promise<Void> {
        networkProvider.resetPassword(email: email)
    }

    func logout() {
        keychainProvider.email = nil
        keychainProvider.password = nil
        keychainProvider.token = nil
        keychainProvider.tokenExpirationDate = nil
    }


    // MARK: - Users

    func currentUser() -> Promise<PublicUser> {
        let result: Promise<PublicUser>
        switch userState {
        case .loggedIn:
            result = networkProvider.currentUser(keychainProvider.token.require())
        case .tokenExpired:
            result = refreshToken().then { self.networkProvider.currentUser(self.keychainProvider.token.require()) }
        case .notLoggedIn:
            result = .init(error: CinemaErrors.notLoggedIn)
        }
        return result
    }

    // MARK: - Movies

    func moviesList() -> Promise<[PublicMovie]> {
        networkProvider.allMovies()
    }

}
