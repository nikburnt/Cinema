//
//  Movie.swift
//  backyard
//
//  Created by Nik Burnt on 6/11/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import FluentMySQL


// MARK: - Movie

typealias Movie = PublicMovie
extension Movie: MySQLModel {

    // MARK: - MySQLModel

    static var entity: String = "movies"

}
