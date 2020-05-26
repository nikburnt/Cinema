//
//  Theater+Update.swift
//  backyard
//
//  Created by Nik Burnt on 5/24/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - Theater+Update

extension Theater {

    typealias UpdateData = CreateData


    // MARK: - Public Methods

    func updated(with data: UpdateData) -> Theater {
        var copy = self
        copy.name = data.name
        copy.location = data.location
        copy.description = data.description
        return copy
    }

}
