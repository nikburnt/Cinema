//
//  PublicMovie+Poster.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/12/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - PublicMovie+Poster

extension PublicMovie {

    var posterUrl: URL? { poster != nil ? URL.host.appendingPathComponent(poster.require()) : nil }

}
