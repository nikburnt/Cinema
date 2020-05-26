//
//  Auditorium+Create.swift
//  backyard
//
//  Created by Nik Burnt on 5/26/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - Auditorium+Create

extension Auditorium {

    // MARK: - Public Structures

    struct CreateData: Content, Validatable, Reflectable {

        // MARK: - Public Variables

        var theaterId: Int
        var name: String
        var description: String


        // MARK: - Validatable

        static func validations() throws -> Validations<CreateData> {
            var validations = Validations(CreateData.self)
            let charactersSet: Validator<String> = .characterSet(.alphanumerics + .whitespacesAndNewlines + .punctuationCharacters + .symbols)
            try validations.add(\.name, charactersSet && .count(3...))
            try validations.add(\.description, charactersSet && .count(12...))
            return validations
        }

    }


    // MARK: - Lifecycle

    init(with data: CreateData) throws {
        self.init(theaterId: data.theaterId, name: data.name, description: data.description)
    }

}
