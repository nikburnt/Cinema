//
//  CommandsProcessor.swift
//  backyard
//
//  Created by Nik Burnt on 5/10/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - CommandsProcessor

protocol CommandsProcessor {

    // Should always be called before any actions performed; otherwise, the app will crash
    // Database connection setup function, this check is not needed here
    // swiftlint:disable function_parameter_count
    func initialize(host: String, port: Int, login: String, password: String, database: String)

    func start()
    func listStaff()
    func addStaff(with email: String)
    func removeStaff(with email: String)

}
