//
//  MySQLDataStorage.swift
//  backyard
//
//  Created by Nik Burnt on 5/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Async
import Crypto
import FluentMySQL
import MySQL
import SwiftyBeaver


// MARK: - MySQLDataStorage

struct MySQLDataStorage: DataStorage {

    // MARK: - Private Variables

    private let database: MySQLDatabase

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 10)


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

    func listOfStaff() -> Future<[User]> {
        database
            .newConnection(on: eventLoopGroup.next())
            .then { connection -> EventLoopFuture<[User]> in
                User.entity = "staff_users"
                return connection.raw("SELECT * FROM staff_users").all(decoding: User.self)
            }
            .always { User.entity = "users" }
    }

    func addStaff(email: String, password: String) -> Future<Void> {
        var passwordHash: String = ""
        do {
            passwordHash = try BCrypt.hash(password)
        } catch {
            SwiftyBeaver.error("Password hashing error: \(error.localizedDescription)", context: error)
            return eventLoopGroup.next().newFailedFuture(error: error)
        }

        return database
            .newConnection(on: eventLoopGroup.next())
            .then { $0.raw("CALL AddStaff('\(email)', '\(passwordHash)');").all() }
            .then { _ in self.eventLoopGroup.future() }
    }

    func removeStaff(email: String) -> Future<Void> {
        database
            .newConnection(on: eventLoopGroup.next())
            .then { $0.raw("CALL RemoveStaff('\(email)');").all() }
            .then { _ in self.eventLoopGroup.future() }
    }

    func removeExpiredTokens(olderThan days: UInt) -> Future<Void> {
        database
            .newConnection(on: eventLoopGroup.next())
            .then { $0.raw("CALL RemoveExpiredTokens('\(days)');").all() }
            .then { _ in self.eventLoopGroup.future() }
    }


    // MARK: - Private Methods

    private func registerModels() {
        User.defaultDatabase = .mysql
        Token.defaultDatabase = .mysql
        Theater.defaultDatabase = .mysql
        Auditorium.defaultDatabase = .mysql
    }

}
