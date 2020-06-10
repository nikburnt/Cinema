//
//  PasswordFieldDataSource.swift
//  Cinemagic
//
//  Created by Nik Burnt on 5/31/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import AnimatedField


// MARK: - PasswordFieldDataSource

class PasswordFieldDataSource: AnimatedFieldDataSource {

    // MARK: - AnimatedFieldDataSource

    func animatedFieldValidationMatches(_ animatedField: AnimatedField) -> String? {
        PasswordStrength.averagePasswordRegex
    }

    func animatedFieldValidationError(_ animatedField: AnimatedField) -> String? {
        "Должен быть 6 символов a-z и как минимум одной цифры"
    }

}
