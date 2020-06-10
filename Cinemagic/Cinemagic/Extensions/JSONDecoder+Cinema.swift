//
//  JSONDecoder+Cinema.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/10/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - JSONDecoder+Cinema

extension JSONDecoder {

    // MARK: - Public Methods

    static func decode<T>(_ data: Data) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let result = try decoder.decode(T.self, from: data)
        return result
    }
}
