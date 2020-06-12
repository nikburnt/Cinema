//
//  PublicMovie.swift
//  
//
//  Created by Nik Burnt on 6/11/20.
//

import Foundation


// MARK: - Movie

struct PublicMovie: Codable {

    // MARK: - Codable Enum

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case startAt = "start_at"
        case endAt = "end_at"
        case maxTickets = "max_tickets"
        case poster
    }


    // MARK: - Public Variables

    var id: Int?

    var title: String
    var description: String
    var startAt: Date
    var endAt: Date
    var maxTickets: Int

    var poster: String?

}
