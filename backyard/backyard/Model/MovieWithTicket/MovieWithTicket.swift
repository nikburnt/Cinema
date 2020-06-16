//
//  Ticket.swift
//  backyard
//
//  Created by Nik Burnt on 6/15/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import FluentMySQL


// MARK: - MovieWithTicket

struct MovieWithTicket: MySQLModel {

    // MARK: - Public Variables

    var id: Int?
    var userId: Int?

    var title: String
    var description: String
    var showtime: Date
    var tickets: Int = 30

    var poster: String?


    // MARK: - Codable Enum

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case description
        case showtime
        case tickets
        case poster
    }


    // MARK: - MySQLModel

    static var entity: String = "movies_with_tickets"

}
