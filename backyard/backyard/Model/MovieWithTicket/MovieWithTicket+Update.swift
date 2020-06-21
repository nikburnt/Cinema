//
//  MovieWithTicket+Update.swift
//  backyard
//
//  Created by Nik Burnt on 6/17/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - MovieWithTicket+Update

extension MovieWithTicket {

    // MARK: - Public Structures

    struct UpdateData: Content {
        let id: Int?
    }

}
