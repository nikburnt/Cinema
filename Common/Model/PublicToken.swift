//
//  PublicToken.swift
//  
//
//  Created by Nik Burnt on 6/10/20.
//

import Foundation


// MARK: - PublicToken

struct PublicToken: Codable {

    var token: String
    var expirationDate: Date

    enum CodingKeys: String, CodingKey {
        case token
        case expirationDate = "expiration_date"
    }

}
