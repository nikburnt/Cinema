//
//  BaseDestination+DefaultConfig.swift
//  backyard
//
//  Created by Nik Burnt on 5/13/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import SwiftyBeaver


// MARK: - BaseDestination+DefaultConfig

extension BaseDestination {

    // MARK: - Public Methods

    func applyDefaultConfig() {
        self.levelString.debug = "DBG"
        self.levelString.error = "ERR"
        self.levelString.info = "INF"
        self.levelString.verbose = "VRB"
        self.levelString.warning = "WRN"
        #if DEBUG
        self.asynchronously = false
        self.minLevel = .verbose
        #else
        self.asynchronously = true
        self.minLevel = .info
        #endif
        self.format =  "$DYYYY-MM-dd'T'HH:mm:ss.SSS$d $C[$L]$c [$N] $F:$l - $M $X"
    }

}
