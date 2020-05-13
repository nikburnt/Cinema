//
//  Backyard.swift
//  backyard
//
//  Created by Nik Burnt on 5/13/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - Backyard

class Backyard: CommandsProcessor {

    // MARK: - Private Variables

    // Those values should always be presented before usage, otherwise check the integration
    // swiftlint:disable implicitly_unwrapped_optional
    private var host: String!
    private var port: Int!
    private var login: String!
    private var password: String!
    private var database: String!
    // swiftlint:enable implicitly_unwrapped_optional


    // MARK: - CommandsProcessor

    // Database connection setup function, this check is not needed here
    // swiftlint:disable function_parameter_count
    func initialize(host: String, port: Int, login: String, password: String, database: String) {
        self.host = host
        self.port = port
        self.login = login
        self.password = password
        self.database = database
    }

    func start() {

    }

    func listStaff() {

    }

    func addStaff(with email: String) {

    }

    func removeStaff(with email: String) {

    }

}
