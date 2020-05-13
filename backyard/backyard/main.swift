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
    try CommandLineApp.run(using: Backyard())
} catch {
    CommandLineApp.exit(withError: error)
}

RunLoop.main.run()
