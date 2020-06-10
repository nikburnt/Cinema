//
//  AnimatedField+Types.swift
//  Cinemagic
//
//  Created by Nik Burnt on 5/31/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import AnimatedField


// MARK: - AnimatedField+Types

extension AnimatedField {

    // MARK: - Public Methods

    func setupEmail(with dataSource: AnimatedFieldDataSource) {
        self.dataSource = dataSource

        self.placeholder = "Адрес электронной почты"
        self.format = .common
    }

    func setupPassword(with dataSource: AnimatedFieldDataSource) {
        self.dataSource = dataSource

        self.placeholder = "Пароль"
        self.format = .common
        self.isSecure = true
    }

}
