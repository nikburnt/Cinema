//
//  main.swift
//  backyard
//
//  Created by Nik Burnt on 5/8/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation
import SwiftyBeaver


do {
    SwiftyBeaver.configure()

    let output = BackyardOutput()
    output.appExitRequired = { CommandLineApp.exit(withError: $0) }

    let input = Backyard(output)
    try CommandLineApp.run(using: input)
} catch {
    CommandLineApp.exit(withError: error)
}

RunLoop.main.run()
