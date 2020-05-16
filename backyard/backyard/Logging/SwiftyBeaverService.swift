//
//  SwiftyBeaverService.swift
//  backyard
//
//  Created by Nik Burnt on 5/16/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Logging
import Service
import SwiftyBeaver


// MARK: - LogLevel

extension LogLevel {

    var style: SwiftyBeaver.Level {
        switch self {
        case .verbose:
            return .verbose
        case .debug, .custom:
            return .debug
        case .info:
            return .info
        case .warning:
            return .warning
        case .error, .fatal:
            return .error
        }
    }

}


// MARK: - SwiftyBeaverService

struct SwiftyBeaverService: Logger, Service {

    // MARK: - Logger

    // Not my protocol, this check is not needed here
    // swiftlint:disable function_parameter_count
    func log(_ string: String, at level: LogLevel, file: String, function: String, line: UInt, column: UInt) {
        SwiftyBeaver.custom(level: level.style, message: string, file: file, function: function, line: Int(line))
    }

}
