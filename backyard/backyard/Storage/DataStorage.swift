//
//  DataStorage.swift
//  backyard
//
//  Created by Nik Burnt on 5/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Async
import Fluent


// MARK: - DataStorage

protocol DataStorage {

    // Storage initialzation, this check is not needed here
    // swiftlint:disable function_parameter_count
    init(host: String, port: Int, login: String, password: String, database: String)

    func register(on services: inout Services) throws

    func listOfStaff() -> Future<[User]>
    func addStaff(email: String, password: String) -> Future<Void>
    func removeStaff(email: String) -> Future<Void>

}
