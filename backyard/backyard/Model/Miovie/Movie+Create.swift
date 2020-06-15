//
//  Movie+Create.swift
//  backyard
//
//  Created by Nik Burnt on 6/11/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - Movie+Create

extension Movie: CommonCreate {

    // MARK: - Public Structures

    struct CreateData: Content, Validatable, Reflectable {

        // MARK: - Public Variables

        var title: String
        var description: String
        var showtime: Date


        // MARK: - Validatable

        static func validations() throws -> Validations<CreateData> {
            var validations = Validations(CreateData.self)
            let charactersSet: Validator<String> = .characterSet(.alphanumerics + .whitespacesAndNewlines + .punctuationCharacters + .symbols)
            try validations.add(\.title, charactersSet && .count(1...50))
            try validations.add(\.description, charactersSet && .count(12...1000))
            return validations
        }

    }


    // MARK: - Lifecycle

    init(with data: CreateData) throws {
        self.init(title: data.title, description: data.description, showtime: data.showtime, tickets: 30)
    }

}
