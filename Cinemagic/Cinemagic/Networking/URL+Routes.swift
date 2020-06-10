//
//  URL+Routes.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/6/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - Routes

// Routes Declaration, this check not needed
// swiftlint:disable nesting
extension URL {

    private static let host: URL = "http://nikburnttmbpro2019.ddns.net:8080/"

    // Routes Declaration, this check not needed
    // swiftlint:disable type_name
    enum v1 {

        private static let v1Route = host.appendingPathComponent("v1")

        enum users {

            private static let usersRoute = v1Route.appendingPathComponent("users")

            static let login = usersRoute.appendingPathComponent("login")
            static let register = usersRoute.appendingPathComponent("register")
            static let current = usersRoute.appendingPathComponent("current")
            static let resetPassword = usersRoute.appendingPathComponent("reset-password")
            static let uploadAvatar = current.appendingPathComponent("upload-avatar")

        }

    }

}
