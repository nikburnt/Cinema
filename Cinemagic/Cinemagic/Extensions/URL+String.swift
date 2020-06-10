//
//  URL+String.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/6/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation

import Require


// MARK: - URL+String

extension URL: ExpressibleByStringLiteral {

    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)").require(hint: "Invalid URL string literal: \(value)")
    }

}
