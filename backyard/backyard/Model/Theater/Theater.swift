//
//  Theater.swift
//  backyard
//
//  Created by Nik Burnt on 5/23/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import FluentMySQL


// MARK: - Theater

struct Theater: MySQLModel {

    // MARK: - MySQLModel

    static var entity: String = "theaters"


    // MARK: - Public Variables

    var id: Int?

    var name: String
    var location: String
    var description: String

    var picture: String?

}
