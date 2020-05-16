//
//  MySQLDataStorage.swift
//  backyard
//
//  Created by Nik Burnt on 5/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import FluentMySQL
import MySQL
import PromiseKit
import SwiftyBeaver


// MARK: - MySQLDataStorage

struct MySQLDataStorage: DataStorage {

    // MARK: - Private Variables

    private let database: MySQLDatabase
    private let worker = MultiThreadedEventLoopGroup(numberOfThreads: 10)


    // MARK: - Lifecycle

    init(host: String, port: Int, login: String, password: String, database: String) {
        let config = MySQLDatabaseConfig(hostname: host,
                                         port: port,
                                         username: login,
                                         password: password,
                                         database: database,
                                         capabilities: .default,
                                         characterSet: .utf8mb4_unicode_ci,
                                         transport: .unverifiedTLS)
        self.database = MySQLDatabase(config: config)
    }


    // MARK: - DataStorage

    func register(on services: inout Services) throws {
        try services.register(MySQLProvider())
        try services.register(FluentMySQLProvider())

        var databases = DatabasesConfig()
        databases.enableLogging(on: DatabaseIdentifier<MySQLDatabase>.mysql)
        databases.add(database: database, as: .mysql)
        services.register(databases)

        registerModels()
    }

    func listOfStaff() -> PromiseKit.Promise<[User]> {
        Promise { seal in
            database
                .newConnection(on: worker.next())
                .then { connection -> EventLoopFuture<[User]> in
                    User.entity = "staff_users"
                    return connection.raw("SELECT * FROM staff_users").all(decoding: User.self)
                }
                .do { seal.fulfill($0) }
                .catch { seal.reject($0) }
                .always { User.entity = "users" }
        }
    }

    func addStaff(email: String, password: String) -> PromiseKit.Promise<Void> {
        var passwordHash: String = ""
        do {
            passwordHash = try password.soiledHash()
        } catch {
            SwiftyBeaver.error("Password hashing error: \(error.localizedDescription)", context: error)
            return .init(error: error)
        }

        return Promise { seal in
            database
                .newConnection(on: worker.next())
                .then { $0.raw("CALL AddStaff('\(email)', '\(passwordHash)');").all() }
                .do { _ in seal.fulfill_() }
                .catch { seal.reject($0) }
        }
    }

    func removeStaff(email: String) -> PromiseKit.Promise<Void> {
        Promise { seal in
            database
                .newConnection(on: worker.next())
                .then { $0.raw("CALL RemoveStaff('\(email)');").all() }
                .do { _ in seal.fulfill_() }
                .catch { seal.reject($0) }
        }
    }


    // MARK: - Private Methods

    private func registerModels() {
        User.defaultDatabase = .mysql
        Password.defaultDatabase = .mysql
    }

}
