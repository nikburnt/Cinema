//
//  Movie+Update.swift
//  backyard
//
//  Created by Nik Burnt on 6/11/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - Movie+Update

extension Movie: CommonUpdate {

    typealias UpdateData = CreateData


    // MARK: - Public Methods

    func updated(with data: UpdateData) -> Movie {
        var copy = self
        copy.title = data.title
        copy.description = data.description
        copy.startAt = data.startAt
        copy.endAt = data.endAt
        return copy
    }

}
