//
//  BackyardVapor.swift
//  backyard
//
//  Created by Nik Burnt on 5/16/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation

import Authentication
import Vapor


// MARK: - BackyardVapor

class BackyardVapor {

    // MARK: - Private Variables

    private let vaporApplication: Application
    private let router: Router
    private let mailingService: MailingService


    // MARK: - Lifecycle

    init(_ dataStorage: DataStorage, mailingService: MailingService) throws {
        self.mailingService = mailingService

        // Config

        var config: Config = .default()
        config.prefer(SwiftyBeaverService.self, for: Logger.self)

        // Environment

        let environment: Environment
        #if DEBUG
        environment = .development
        #else
        environment = .production
        #endif

        // Services

        var services: Services = .default()

        services.register(SwiftyBeaverService(), as: Logger.self)

        try services.register(AuthenticationProvider())

        try dataStorage.register(on: &services)

        let router = EngineRouter.default()
        services.register(router, as: Router.self)
        self.router = router

        var middlewares = MiddlewareConfig()
        middlewares.use(FileMiddleware.self)
        middlewares.use(ErrorMiddleware.self)
        services.register(middlewares)

        // Application

        self.vaporApplication = try Application(config: config, environment: environment, services: services)

        try initRoutes(for: self.router)
    }


    // MARK: - Public Methods

    func start() throws {
        try vaporApplication.run()
    }


    // MARK: - Private Methods

    private func initRoutes(for router: Router) throws {
        let v1Route = router.grouped("v1")

        let usersControllerV1 = UsersControllerV1(mailingService: mailingService)
        try v1Route.register(collection: usersControllerV1)
    }

}
