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

    func launchInInteractiveMode()

    func initialize(host: String, login: String, password: String, database: String)

    func addStaff(with email: String)
    func removeStaff(with email: String)

}
