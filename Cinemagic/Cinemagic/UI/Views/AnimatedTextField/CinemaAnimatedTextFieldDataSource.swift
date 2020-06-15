//
//  CinemaAnimatedTextFieldDataSource.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import AnimatedField


// MARK: - CinemaAnimatedTextFieldDataSource

class CinemaAnimatedTextFieldDataSource: AnimatedFieldDataSource {

    // MARK: - Private Varaibles

    private let validationRegex: String?
    private let validationError: String?
    private let limit: Int?
    private let nextResponder: UIResponder?
    private let completion: (() -> Void)?


    // MARK: - Lifecycle

    init(validationRegex: String? = nil,
         validationError: String? = nil,
         limit: Int? = nil,
         nextResponder: UIResponder? = nil,
         completion: (() -> Void)? = nil) {
        self.validationRegex = validationRegex
        self.validationError = validationError
        self.limit = limit
        self.nextResponder = nextResponder
        self.completion = completion
    }


    // MARK: - AnimatedFieldDataSource

    func animatedFieldShouldReturn(_ animatedField: AnimatedField) -> Bool {
        nextResponder?.becomeFirstResponder()
        completion?()
        return true
    }

    func animatedFieldLimit(_ animatedField: AnimatedField) -> Int? {
        limit
    }

    func animatedFieldValidationMatches(_ animatedField: AnimatedField) -> String? {
        validationRegex
    }

    func animatedFieldValidationError(_ animatedField: AnimatedField) -> String? {
        validationError
    }

}
