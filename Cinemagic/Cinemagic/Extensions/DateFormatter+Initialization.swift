//
//  DateFormatter+Initialization.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/12/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - Extension

extension DateFormatter {

    // MARK: - Public Methods

    static func dateFormatter(using format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = format
        return dateFormatter
    }

}
