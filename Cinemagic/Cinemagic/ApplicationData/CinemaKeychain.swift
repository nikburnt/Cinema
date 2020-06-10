//
//  CinemaKeychain.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/9/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation

import KeychainAccess


// MARK: - Private Constants

private let tokenKey = "token"
private let tokenExpirationDateKey = "token-expiration"
private let emailKey = "email"
private let passwordKey = "password"

// MARK: - CinemaKeychain

class CinemaKeychain {

    // MARK: - Private Variables

    private let keychain = Keychain(service: "com.nikburnt.bntu.cinema.cinemagic")


    // MARK: - Public Variables

    var token: String? {
        get { keychain[tokenKey] }
        set { keychain[tokenKey] = newValue }
    }

    var tokenExpirationDate: Date? {
        get {
            guard let stringTimestamp = keychain[tokenExpirationDateKey], let timestamp = TimeInterval(stringTimestamp) else {
                return nil
            }

            return Date(timeIntervalSince1970: timestamp)

        }
        set { keychain[tokenExpirationDateKey] = newValue?.timeIntervalSince1970.description }
    }

    var email: String? {
        get { keychain[emailKey] }
        set { keychain[emailKey] = newValue }
    }

    var password: String? {
        get { keychain[passwordKey] }
        set { keychain[passwordKey] = newValue }
    }

}
