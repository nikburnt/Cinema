//
//  BaseDestination+ConsoleDestination.swift
//  backyard
//
//  Created by Nik Burnt on 5/13/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import SwiftyBeaver


// MARK: - BaseDestination+ConsoleDestination

extension BaseDestination {

    // MARK: - Public Static Properties

    static var console: BaseDestination  = {
        let destination = ConsoleDestination()
        destination.applyDefaultConfig()
        destination.useTerminalColors = true
        return destination
    }()

}
