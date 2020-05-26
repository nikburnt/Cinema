//
//  Theater+Create.swift
//  backyard
//
//  Created by Nik Burnt on 5/24/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - Theater+Create

extension Theater {

    // MARK: - Public Structures

    struct CreateData: Content, Validatable, Reflectable {

        // MARK: - Public Variables

        var name: String
        var location: String
        var description: String


        // MARK: - Validatable

        static func validations() throws -> Validations<CreateData> {
            var validations = Validations(CreateData.self)
            let charactersSet: Validator<String> = .characterSet(.alphanumerics + .whitespacesAndNewlines + .punctuationCharacters + .symbols)
            try validations.add(\.name, charactersSet && .count(3...))
            try validations.add(\.location, charactersSet && .count(8...))
            try validations.add(\.description, charactersSet && .count(12...))
            return validations
        }

    }


    // MARK: - Lifecycle

    init(with data: CreateData) throws {
        self.init(name: data.name, location: data.location, description: data.description)
    }

}
