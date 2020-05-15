//
//  PasswordGenerator.swift
//  backyard
//
//  Created by Nik Burnt on 5/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - Private Constants

private let alphabetSymbolsLowercase = "abcdefghijklmnopqrstuvwxyz"
private let alphabetSymbolsUppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
private let digitsSymbols = "0123456789"
private let specialSymbols = "!@#$%^&*()-=_+"


// MARK: - PasswordGenerator

enum PasswordGenerator {

    static func generatePassword(lowercase: UInt = 4, uppercase: UInt = 4, digits: UInt = 2, special: UInt = 2) -> String {
        var symbolsPull: [String] = []
        (0..<lowercase).forEach { _ in symbolsPull.append(alphabetSymbolsLowercase) }
        (0..<uppercase).forEach { _ in symbolsPull.append(alphabetSymbolsUppercase) }
        (0..<digits).forEach { _ in symbolsPull.append(digitsSymbols) }
        (0..<special).forEach { _ in symbolsPull.append(specialSymbols) }
        symbolsPull.shuffle()

        let result: String = symbolsPull.reduce(into: "") { result, symbols in result.append(symbols.randomElement() ?? " ") }
        return result
    }

}
