//
//  CommonCRUDController.swift
//  backyard
//
//  Created by Nik Burnt on 5/26/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import FluentMySQL
import Vapor


// MARK: - CommonCreate

protocol CommonCreate {

    associatedtype CreateData: Content, Validatable, Reflectable
    init(with data: CreateData) throws

}


// MARK: - CommonUpdate

protocol CommonUpdate {

    associatedtype UpdateData: Content, Validatable, Reflectable
    func updated(with data: UpdateData) -> Self

}


// MARK: - PictureUpdate

protocol PictureUpdate {

    func updated(with data: Data) throws -> Self

}


// MARK: - CommonCRUDControllerErrors

enum CommonCRUDControllerErrors: Error {
    case convertionToFutureFailed
}


// MARK: - AuditoriumsControllerV1

typealias CRUDModel = MySQLModel & Content & Parameter & CommonCreate & CommonUpdate & PictureUpdate
struct CommonCRUDController<T: CRUDModel>: RouteCollection {

    // MARK: - Private Variables

    private let route: String


    // MARK: - Lifecycle

    init(route: String) {
        self.route = route
    }


    // MARK: - RouteCollection

    func boot(router: Router) throws {
        // Root Route
        let unauthorizedRoute = router.grouped(route)


        // Bearer Authentication for requests

        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let authorizedRoute = unauthorizedRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)

        authorizedRoute.get(use: getAllHandler)
        authorizedRoute.get(T.parameter, use: getHandler)
        authorizedRoute.post(T.CreateData.self, use: addHandler)
        authorizedRoute.put(T.parameter, use: updateHandler)
        authorizedRoute.patch(T.parameter, use: addPictureHandler)
        authorizedRoute.delete(T.parameter, use: deleteHandler)
    }


    // MARK: - Private Methods

    private func getAllHandler(_ request: Request) throws -> Future<[T]> {
        guard try request.authenticated(User.self)?.role == .staff else {
            throw Abort(.forbidden, reason: "You are not allowed to get \(route).")
        }

       return  T.query(on: request).decode(data: T.self).all()
    }

    private func getHandler(_ request: Request) throws -> Future<T> {
        guard try request.authenticated(User.self)?.role == .staff else {
            throw Abort(.forbidden, reason: "You are not allowed to get \(route).")
        }

        return try request.parameters.nextFuture(T.self)
    }

    private func addHandler(_ request: Request, data: T.CreateData) throws -> Future<T> {
        guard try request.authenticated(User.self)?.role == .staff else {
            throw Abort(.forbidden, reason: "You are not allowed to add \(route).")
        }

        try data.validate()

        return try T(with: data).create(on: request)
    }

    private func updateHandler(_ request: Request) throws -> Future<T> {
        guard try request.authenticated(User.self)?.role == .staff else {
            throw Abort(.forbidden, reason: "You are not allowed to update \(route).")
        }

        return try flatMap(to: T.self,
                           request.parameters.nextFuture(T.self),
                           request.content.decode(T.UpdateData.self)) { data, updateData in
            try updateData.validate()
            return data.updated(with: updateData).save(on: request)
        }
    }

    private func addPictureHandler(_ request: Request) throws -> Future<T> {
        guard try request.authenticated(User.self)?.role == .staff else {
            throw Abort(.forbidden, reason: "You are not allowed to add picture to \(route).")
        }

        return try flatMap(to: T.self,
                           request.parameters.nextFuture(T.self),
                           request.http.body.consumeData(on: request)) { data, imageData in
            try data.updated(with: imageData).save(on: request)
        }
    }

    private func deleteHandler(_ request: Request) throws -> Future<T> {
        guard try request.authenticated(User.self)?.role == .staff else {
            throw Abort(.forbidden, reason: "You are not allowed to remove \(route).")
        }

        return try request.parameters.nextFuture(T.self).delete(on: request)
    }

}


// MARK: - ParametersContainer+Future

extension ParametersContainer {

    func nextFuture<P>(_ parameter: P.Type) throws -> EventLoopFuture<P> where P: Parameter {
        guard let future = try self.next(parameter) as? EventLoopFuture<P> else {
            throw CommonCRUDControllerErrors.convertionToFutureFailed
        }
        return future
    }

}
