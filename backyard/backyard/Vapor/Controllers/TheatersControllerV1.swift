//
//  TheatersControllerV1.swift
//  backyard
//
//  Created by Nik Burnt on 5/23/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - TheatersControllerV1

struct TheatersControllerV1: RouteCollection {

    // MARK: - RouteCollection

    func boot(router: Router) throws {
        // Root Route
        let theatersRoute = router.grouped("theaters")

        
        // Bearer Authentication for requests

        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let authenticatedRoute = theatersRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)


        // Public Actions

        theatersRoute.get(use: getAllHandler)
        theatersRoute.get(Theater.parameter, use: getHandler)


        // Staff Only Actions

        authenticatedRoute.post(Theater.CreateData.self, use: addHandler)
        authenticatedRoute.put(Theater.parameter, use: updateHandler)
        authenticatedRoute.patch(Theater.parameter, use: addPictureHandler)
        authenticatedRoute.delete(Theater.parameter, use: deleteHandler)
    }


    // MARK: - Private Methods

    private func getAllHandler(_ request: Request) throws -> Future<[Theater]> {
        Theater.query(on: request).decode(data: Theater.self).all()
    }

    private func getHandler(_ request: Request) throws -> Future<Theater> {
        try request.parameters.next(Theater.self)
    }

    private func addHandler(_ request: Request, data: Theater.CreateData) throws -> Future<Theater> {
        try data.validate()

        return try Theater(with: data).create(on: request)
    }

    private func updateHandler(_ request: Request) throws -> Future<Theater> {
        try flatMap(to: Theater.self,
                    request.parameters.next(Theater.self),
                    request.content.decode(Theater.UpdateData.self)) { theater, updateData in
            theater.updated(with: updateData).save(on: request)
        }
    }

    private func addPictureHandler(_ request: Request) throws -> Future<Theater> {
        try flatMap(to: Theater.self,
                    request.parameters.next(Theater.self),
                    request.http.body.consumeData(on: request)) { theater, imageData in
            try theater.updated(with: imageData).save(on: request)
        }
    }

    private func deleteHandler(_ request: Request) throws -> Future<Theater> {
        try request.parameters.next(Theater.self).delete(on: request)
    }

}
