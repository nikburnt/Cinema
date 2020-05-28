//
//  PasswordStrengts+Enough.swift
//  backyard
//
//  Created by Nik Burnt on 5/21/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - Private Constants

private let minimumStrength = PasswordStrength.average


// MARK: - PasswordStrengts+Enough

extension PasswordStrength {

    // MARK: - Public Methods

    static func isStrongEnough(password: String) -> Bool {
        let result = PasswordStrength(password: password) > minimumStrength
        return result
    }

}


// MARK: - String+PasswordStrengts+Enough

extension String {

    // MARK: - Public Variables

    var isStrongEnoughPassword: Bool { PasswordStrength.isStrongEnough(password: self) }

}
