//
//  PublicMovie+Equatable.swift
//  CinemagicTests
//
//  Created by Nik Burnt on 6/20/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

@testable
import Cinemagic

import Foundation
import Nimble


// MARK: - PublicMovie+Equatable

extension PublicMovie: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.description == rhs.description
            && lhs.showtime == rhs.showtime
            && lhs.tickets == rhs.tickets
            && lhs.poster == rhs.poster
    }

    static public func ~= (lhs: Self, rhs: Self?) -> Bool {
        guard let rhs = rhs else { return false }
        return lhs ~= rhs
    }

    static public func ~= (lhs: Self?, rhs: Self) -> Bool {
        guard let lhs = lhs else { return false }
        return lhs ~= rhs
    }

    static public func ~= (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title
            && lhs.description == rhs.description
            && lhs.showtime == rhs.showtime
    }

}

public func ~= (lhs: PublicMovie?, rhs: PublicMovie?) -> Bool {
    if let rhs = rhs, let lhs = lhs {
        return lhs ~= rhs
    } else if let rhs = rhs {
        return lhs ~= rhs
    } else if let lhs = lhs {
        return lhs ~= rhs
    } else {
        return true
    }
}

public func ~=(lhs: Expectation<PublicMovie>, rhs: PublicMovie?) {
    let message = FailureMessage(stringValue: "Movies \(lhs) and \(String(describing: rhs)) are not nearly equal.")

    let moviesAreNearEqual = (try? lhs.expression.evaluate()) ~= rhs
    lhs.verify(moviesAreNearEqual, message)
}
