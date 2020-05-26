//
//  AuditoriumsControllerV1.swift
//  backyard
//
//  Created by Nik Burnt on 5/26/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - AuditoriumsControllerV1

struct AuditoriumsControllerV1: RouteCollection {

    // MARK: - RouteCollection

    func boot(router: Router) throws {
        // Root Route
        let auditoriumsRoute = router.grouped("auditoriums")


        // Bearer Authentication for requests

        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let authenticatedRoute = auditoriumsRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)


        // Public Actions

        auditoriumsRoute.get(use: getAllHandler)
        auditoriumsRoute.get(Auditorium.parameter, use: getHandler)


        // Staff Only Actions

        authenticatedRoute.post(Auditorium.CreateData.self, use: addHandler)
        authenticatedRoute.put(Auditorium.parameter, use: updateHandler)
        authenticatedRoute.patch(Auditorium.parameter, use: addPictureHandler)
        authenticatedRoute.delete(Auditorium.parameter, use: deleteHandler)
    }


    // MARK: - Private Methods

    private func getAllHandler(_ request: Request) throws -> Future<[Auditorium]> {
        Auditorium.query(on: request).decode(data: Auditorium.self).all()
    }

    private func getHandler(_ request: Request) throws -> Future<Auditorium> {
        try request.parameters.next(Auditorium.self)
    }

    private func addHandler(_ request: Request, data: Auditorium.CreateData) throws -> Future<Auditorium> {
        guard try request.authenticated(User.self)?.role == .staff else {
            throw Abort(.forbidden, reason: "You are not allowed to add auditorium.")
        }

        try data.validate()

        return try Auditorium(with: data).create(on: request)
    }

    private func updateHandler(_ request: Request) throws -> Future<Auditorium> {
        guard try request.authenticated(User.self)?.role == .staff else {
            throw Abort(.forbidden, reason: "You are not allowed to update auditorium.")
        }

        return try flatMap(to: Auditorium.self,
                           request.parameters.next(Auditorium.self),
                           request.content.decode(Auditorium.UpdateData.self)) { auditorium, updateData in
            auditorium.updated(with: updateData).save(on: request)
        }
    }

    private func addPictureHandler(_ request: Request) throws -> Future<Auditorium> {
        guard try request.authenticated(User.self)?.role == .staff else {
            throw Abort(.forbidden, reason: "You are not allowed to add picture to auditorium.")
        }

        return try flatMap(to: Auditorium.self,
                           request.parameters.next(Auditorium.self),
                           request.http.body.consumeData(on: request)) { auditorium, imageData in
            try auditorium.updated(with: imageData).save(on: request)
        }
    }

    private func deleteHandler(_ request: Request) throws -> Future<Auditorium> {
        guard try request.authenticated(User.self)?.role == .staff else {
            throw Abort(.forbidden, reason: "You are not allowed to remove auditorium.")
        }

        return try request.parameters.next(Auditorium.self).delete(on: request)
    }

}
