//
//  File.swift
//  backyard
//
//  Created by Nik Burnt on 6/16/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - MovieWithTicket+Public

extension MovieWithTicket {

    func makePublic(_ currentUserId: Int) -> PublicMovieWithTicket {
        PublicMovieWithTicket(id: id, title: title, description: description, showtime: showtime, tickets: tickets, poster: poster, hasTicket: userId == currentUserId)
    }

}
