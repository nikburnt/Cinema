//
//  User+Avatar.swift
//  backyard
//
//  Created by Nik Burnt on 5/22/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - Private Variables

private let publicFolder = "Public"
private let avatarsFolder = "avatars"
private let iamgeExtension = "image"


// MARK: - User+Avatar

extension User {

    // MARK: - Public Methods

    func updated(with data: Data) throws -> User {
        let relativePath = URL(fileURLWithPath: "/")
            .appendingPathComponent(avatarsFolder)
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(iamgeExtension)
        let filePath = URL(fileURLWithPath: publicFolder).appendingPathComponent(relativePath.path)

        try data.write(to: filePath)

        var copy = self
        copy.avatar = relativePath.path
        return copy
    }

}
