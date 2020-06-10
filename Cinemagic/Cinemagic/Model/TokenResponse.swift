//
//  TokenResponse.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/6/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - Token

struct TokenResponse: Codable {

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case token
        case expirationDate = "expiration_date"
    }


    // MARK: - Public Variables

    var token: String
    var expirationDate: Date

}
