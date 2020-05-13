//
//  SwiftyBeaver+Configure.swift
//  backyard
//
//  Created by Nik Burnt on 5/13/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import SwiftyBeaver


// MARK: - SwiftyBeaver

extension SwiftyBeaver {

    // MARK: - Public Static Methods

    static func configure() {
        SwiftyBeaver.addDestination(.console)
        SwiftyBeaver.addDestination(.file)
        SwiftyBeaver.addDestination(.cloud)
    }

}
