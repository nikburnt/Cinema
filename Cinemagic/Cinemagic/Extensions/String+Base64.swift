//
//  String+Base64.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/8/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - StringErrors

enum StringErrors: Error {
    case stringCouldNotBePresentedAsData(String)
}


// MARK: - String+Base64

extension String {

    // MARK: - Public Methods

    func base64() throws -> String {
        guard let data = self.data(using: .utf8) else {
            throw StringErrors.stringCouldNotBePresentedAsData(self)
        }

        let result = data.base64EncodedString()
        return result
    }

}
