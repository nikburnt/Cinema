//
//  String+Crypto.swift
//  backyard
//
//  Created by Nik Burnt on 5/15/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Cryptor


// MARK: - Private Constants

private let salt = "May the force be with you."


// MARK: - String+Crypto

extension String {

    // MARK: - Public Methods

    func soiledHash() throws -> String  {
        let key = try PBKDF.deriveKey(fromPassword: self, salt: salt, prf: .sha256, rounds: 1, derivedKeyLength: UInt(Cryptor.Algorithm.aes.defaultKeySize))
        let result = CryptoUtils.hexString(from: key)
        return result
    }

}
