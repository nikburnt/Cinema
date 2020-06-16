//
//  MovieWithTicket.swift
//  
//
//  Created by Nik Burnt on 6/15/20.
//

import Foundation


// MARK: - Movie

struct PublicMovieWithTicket: Codable {

    // MARK: - Public Variables

    var id: Int?

    var title: String
    var description: String
    var showtime: Date
    var tickets: Int = 30

    var poster: String?

    var hasTicket: Bool = false

    // MARK: - Codable Enum

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case showtime
        case tickets
        case poster
        case hasTicket = "has_tickets"
    }

}
