//
//  BackyardVapor.swift
//  backyard
//
//  Created by Nik Burnt on 5/16/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation

import Vapor


// MARK: - BackyardVapor

class BackyardVapor {

    // MARK: - Private Variables

    private let vaporApplication: Application
    private let router: Router


    // MARK: - Lifecycle

    init(_ dataStorage: DataStorage) throws {
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

        self.initRoutes(for: self.router)
    }


    // MARK: - Public Methods

    func start() throws {
        try vaporApplication.run()
    }


    // MARK: - Private Methods

    private func initRoutes(for router: Router) {
        // Basic "It works" example
        router.get { _ in
            "It works!"
        }

        // Basic "Hello, world!" example
        router.get("hello") { _ in
            "Hello, world!"
        }

//        router.get("users") { req in
//            return User.query(on: req).all()
//        }
    }

}
