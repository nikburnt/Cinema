//
//  MovieWithTicketController.swift
//  backyard
//
//  Created by Nik Burnt on 6/15/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import FluentMySQL
import Vapor


// MARK: - MovieWithTicketControllerErrors

enum MovieWithTicketControllerErrors: Error {
    case movieNotFoundedForTicket
}


// MARK: - AuditoriumsControllerV1

struct MovieWithTicketController: RouteCollection {

    // MARK: - RouteCollection

    func boot(router: Router) throws {
        // Root Route
        let unauthorizedRoute = router.grouped("movies-with-tickets")


        // Bearer Authentication for requests

        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let authorizedRoute = unauthorizedRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)

        authorizedRoute.get(use: getAllHandler)
        authorizedRoute.post(MovieWithTicket.UpdateData.self, at: "claim", use: addHandler)
        authorizedRoute.post(MovieWithTicket.UpdateData.self, at: "refound", use: deleteHandler)
    }


    // MARK: - Private Methods

    private func getAllHandler(_ request: Request) throws -> Future<[PublicMovieWithTicket]> {
        let loggedInUser: User = try request.requireAuthenticated()
        let currentUserId = try loggedInUser.requireID()
        return MovieWithTicket.query(on: request)
            .all()
            .map { movies -> [PublicMovieWithTicket] in
                let moviesWithUserTickets = movies.filter { $0.userId == currentUserId }
                let moviesWithUserTicketsIds = moviesWithUserTickets.map { $0.id }
                var mutableMovies = movies
                if moviesWithUserTicketsIds.isEmpty {
                    let uniqueIds = Set(movies.map { $0.id })
                    mutableMovies = uniqueIds.compactMap { movieId in movies.first { $0.id == movieId } }
                } else {
                    mutableMovies.removeAll { moviesWithUserTicketsIds.contains($0.id) && $0.userId != currentUserId }
                }
                let result = mutableMovies.map { $0.makePublic(currentUserId) }
                return result
            }
    }


    private func addHandler(_ request: Request, data: MovieWithTicket.UpdateData) throws -> Future<PublicMovieWithTicket> {
        guard let movieId = data.id else { throw Abort(.badRequest, reason: "Movie has no id.") }
        let loggedInUser: User = try request.requireAuthenticated()
        let currentUserId = try loggedInUser.requireID()
        return request
            .databaseConnection(to: .mysql)
            .then { $0.raw("CALL ClaimTicket(\(currentUserId), \(movieId.description))").all() }
            .then { _ in MovieWithTicket.find(movieId, on: request) }
            .unwrap(or: MovieWithTicketControllerErrors.movieNotFoundedForTicket)
            .map { $0.makePublic(currentUserId) }
    }

    private func deleteHandler(_ request: Request, data: MovieWithTicket.UpdateData) throws -> Future<PublicMovieWithTicket> {
        guard let movieId = data.id else { throw Abort(.badRequest, reason: "Movie has no id.") }
        let loggedInUser: User = try request.requireAuthenticated()
        let currentUserId = try loggedInUser.requireID()
        return request
            .databaseConnection(to: .mysql)
            .then { $0.raw("CALL RefoundTicket(\(currentUserId), \(movieId.description))").all() }
            .then { _ in MovieWithTicket.find(movieId, on: request) }
            .unwrap(or: MovieWithTicketControllerErrors.movieNotFoundedForTicket)
            .map { $0.makePublic(currentUserId) }
    }

}
