//
//  BaseDestination+SBPlatformDestination.swift
//  backyard
//
//  Created by Nik Burnt on 5/13/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation

import SwiftyBeaver


// MARK: - BaseDestination+SBPlatformDestination

extension BaseDestination {

    // MARK: - Public Static Properties

    static var cloud: BaseDestination  = {
        let destination = SBPlatformDestination(appID: "LQnB1W",
                                                appSecret: "kl8tZjql7bqbxwAekqiUbxbil38ywzkl",
                                                encryptionKey: "cxlnqtnxh9wO2bemiJkqaki2Khfkxlpg")
        destination.applyDefaultConfig()
        return destination
    }()

}
