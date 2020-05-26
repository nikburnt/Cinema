//
//  Auditorium.swift
//  backyard
//
//  Created by Nik Burnt on 5/26/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import FluentMySQL


// MARK: - Auditorium

struct Auditorium: MySQLModel {

    // MARK: - MySQLModel

    static var entity: String = "auditoriums"


    // MARK: - Codable Enum

    enum CodingKeys: String, CodingKey {
        case id
        case theaterId = "theater_id"
        case name
        case description
        case picture
    }


    // MARK: - Public Variables

    var id: Int?
    var theaterId: Int

    var name: String
    var description: String

    var picture: String?

}
