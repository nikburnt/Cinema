//
//  BaseDestination+FileDestination.swift
//  backyard
//
//  Created by Nik Burnt on 5/13/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation

import SwiftyBeaver


// MARK: - BaseDestination+FileDestination

extension BaseDestination {

    // MARK: - Public Static Properties

    static var file: BaseDestination  = {
        let destination = FileDestination()
        destination.applyDefaultConfig()
        #if DEBUG
        let currentDirectoryPath = FileManager.default.currentDirectoryPath
        destination.logFileURL = URL(fileURLWithPath: currentDirectoryPath + "/backyard.log")
        #endif
        return destination
    }()

}
