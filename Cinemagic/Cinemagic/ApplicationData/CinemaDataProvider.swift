//
//  CinemaDataProvider.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/9/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation
import UIKit

import PromiseKit


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


    // MARK: - Private Variables

    private var userState: UserState {
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
        .recover {
            self.logout()
            throw $0
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
        guard let token = keychainProvider.token else { return .init(error: CinemaErrors.notLoggedIn) }
        return networkProvider.allMovies(token)
    }

    func create(_ movie: PublicMovie) -> Promise<PublicMovie> {
        guard let token = keychainProvider.token else { return .init(error: CinemaErrors.notLoggedIn) }
        return networkProvider.create(movie, bearer: token)
    }

    func update(_ movie: PublicMovie) -> Promise<PublicMovie> {
        guard let token = keychainProvider.token else { return .init(error: CinemaErrors.notLoggedIn) }
        return networkProvider.update(movie, bearer: token)
    }

    func upload(_ movie: PublicMovie, poster: UIImage) -> Promise<PublicMovie> {
        guard let token = keychainProvider.token else { return .init(error: CinemaErrors.notLoggedIn) }
        return networkProvider.upload(movie, poster: poster, bearer: token)
    }

    func remove(_ movie: PublicMovie) -> Promise<Void> {
        guard let token = keychainProvider.token else { return .init(error: CinemaErrors.notLoggedIn) }
        return networkProvider.remove(movie, bearer: token)
    }


    // MARK: - Movies With Tickets

    func moviesWithTicketsList() -> Promise<[PublicMovieWithTicket]> {
        guard let token = keychainProvider.token else { return .init(error: CinemaErrors.notLoggedIn) }
        return networkProvider.allMoviesWithTickets(bearer: token)
    }

    func claimTicket(for movie: PublicMovieWithTicket) -> Promise<PublicMovieWithTicket> {
        guard let token = keychainProvider.token else { return .init(error: CinemaErrors.notLoggedIn) }
        return networkProvider.claimTicket(for: movie, bearer: token)
    }

    func refoundTicket(for movie: PublicMovieWithTicket) -> Promise<PublicMovieWithTicket> {
        guard let token = keychainProvider.token else { return .init(error: CinemaErrors.notLoggedIn) }
        return networkProvider.refoundTicket(for: movie, bearer: token)
    }


    // MARK: - Private Methods

    func refreshToken() -> Promise<Void> {
        userState == .tokenExpired ? login(email: keychainProvider.email.require(), password: keychainProvider.password.require())
            : .init(error: CinemaErrors.notLoggedIn)
    }

}
