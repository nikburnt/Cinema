//
//  MySQLDataStorage.swift
//  backyard
//
//  Created by Nik Burnt on 5/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import MySQL
import PromiseKit


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

    func register(on services: Services) {
        // register on vapoor services
    }

    func listOfStaff() -> PromiseKit.Promise<[User]> {
        Promise { seal in
            database
                .newConnection(on: worker.next())
                .do { connection in
                    User.entity = "staff_users"
                    connection
                        .raw("SELECT * FROM staff_users")
                        .all(decoding: User.self)
                        .do { seal.fulfill($0) }
                        .catch { seal.reject($0) }
                        .always { User.entity = "users" }
                }
                .catch { seal.reject($0) }
        }
    }

    func addStaff(email: String) -> PromiseKit.Promise<Void> {
        .value
    }

    func removeStaff(email: String) -> PromiseKit.Promise<Void> {
        .value
    }

}
