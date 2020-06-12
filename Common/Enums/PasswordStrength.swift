//
//  PasswordStrength.swift
//  backyard
//
//  Created by Nik Burnt on 5/21/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - PasswordStrength

public enum PasswordStrength: Int, Comparable {

    // MARK: - Public Constants

    public static let weakPasswordRegex = "^(?=.*?[A-Z])(?=.*?[a-z]).{6,24}$"
    public static let averagePasswordRegex = "^(?=.*?[A-Za-z])(?=.*?[0-9]).{6,24}$"
    public static let strongPasswordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,24}$"


    // MARK: - Cases

    case none
    case weak
    case average
    case strong


    // MARK: - Lifecycle

    public init(password: String) {
        if NSPredicate(format:"SELF MATCHES %@", PasswordStrength.strongPasswordRegex).evaluate(with: password) {
            self = .strong
        } else if NSPredicate(format:"SELF MATCHES %@", PasswordStrength.averagePasswordRegex).evaluate(with: password) {
            self = .average
        } else if NSPredicate(format:"SELF MATCHES %@", PasswordStrength.weakPasswordRegex).evaluate(with: password) {
            self = .weak
        } else {
            self = .none
        }
    }


    // MARK: - Comparable

    public static func < (lhs: PasswordStrength, rhs: PasswordStrength) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

}
