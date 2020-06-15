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
        self.keyboardType = .emailAddress
    }

    func setupPassword(with dataSource: AnimatedFieldDataSource) {
        self.dataSource = dataSource

        self.placeholder = "Пароль"
        self.format = .common
        self.isSecure = true
        self.keyboardType = .default
    }

    func setupTitle(with dataSource: AnimatedFieldDataSource) {
        self.dataSource = dataSource

        self.type = .none
        self.format = .common
        self.format.counterEnabled = true
    }

    func setupDescription(with dataSource: AnimatedFieldDataSource) {
        self.dataSource = dataSource

        self.type = .multiline
        self.format = .common
        self.format.counterEnabled = true
    }

}
