//
//  EmailFieldDataSource.swift
//  Cinemagic
//
//  Created by Nik Burnt on 5/31/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import AnimatedField


// MARK: - EmailFieldDataSource

class EmailFieldDataSource: AnimatedFieldDataSource {

    // MARK: - AnimatedFieldDataSource

    func animatedFieldValidationMatches(_ animatedField: AnimatedField) -> String? {
        "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,9}"
    }

    func animatedFieldValidationError(_ animatedField: AnimatedField) -> String? {
        "Неверный формат адреса электронной почты"
    }

}
