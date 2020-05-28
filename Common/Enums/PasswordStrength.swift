//
//  PasswordStrength.swift
//  backyard
//
//  Created by Nik Burnt on 5/21/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

// MARK: - Private Constants

let upperCaseRegex = "^(?=.*[A-Z]).*$"
let lowerCaseRegex = "^(?=.*[a-z]).*$"
let numbersRegex = "^(?=.*[0-9]).*$"
let symbolsRegex = "^(?=.*[!@#%&-_=:;\"'<>,`~\\*\\?\\+\\[\\]\\(\\)\\{\\}\\^\\$\\|\\\\\\.\\/]).*$"


// MARK: - PasswordStrength

enum PasswordStrength: Int, Comparable {

    // MARK: - Cases

    case none
    case weak
    case average
    case strong


    // MARK: - Lifecycle

    init(password: String) {
        guard password.count > 0 else {
            self = .none
            return
        }

        var strength: Int = 0

        
        // Chacking password length

        switch password.count {
        case 1...4: strength += 1
        case 5...8: strength += 2
        default: strength += 3
        }


        // Checking for password symbols

        if password.range(of: upperCaseRegex, options: .regularExpression) != nil {
            strength += 1 // password has at least one upercase symbol
        }

        if password.range(of: lowerCaseRegex, options: .regularExpression) != nil {
            strength += 1 // password has at least one lowercase symbol
        }

        if password.range(of: numbersRegex, options: .regularExpression) != nil {
            strength += 1 // password has at least one number
        }

        if password.range(of: symbolsRegex, options: .regularExpression) != nil {
            strength += 1 // password has at least one special symbol
        }

        switch strength {
        case 1...3: self = .weak
        case 4...5: self = .average
        default: self = .strong
        }
    }


    // MARK: - Comparable

    static func < (lhs: PasswordStrength, rhs: PasswordStrength) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

}
