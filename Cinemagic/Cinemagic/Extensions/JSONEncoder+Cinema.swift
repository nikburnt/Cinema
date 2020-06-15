//
//  JSONEncoder+Cinema.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/15/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - JSONEncoder+Cinema

extension JSONEncoder {

    // MARK: - Public Methods

    static func encodeWithStringDate<T>(_ value: T) throws -> Data where T: Encodable {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let result: Data = try encoder.encode(value)
        return result
    }
}
