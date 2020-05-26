//
//  Auditorium+Update.swift
//  backyard
//
//  Created by Nik Burnt on 5/26/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - Auditorium+Update

extension Auditorium {

    typealias UpdateData = CreateData


    // MARK: - Public Methods

    func updated(with data: UpdateData) -> Auditorium {
        var copy = self
        copy.theaterId = data.theaterId
        copy.name = data.name
        copy.description = data.description
        return copy
    }

}
