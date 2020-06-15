//
//  PublicMovie.swift
//  
//
//  Created by Nik Burnt on 6/11/20.
//

import Foundation


// MARK: - Movie

struct PublicMovie: Codable {

    // MARK: - Public Variables

    var id: Int?

    var title: String
    var description: String
    var showtime: Date
    var tickets: Int = 30

    var poster: String?

}
