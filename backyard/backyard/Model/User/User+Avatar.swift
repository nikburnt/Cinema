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
private let imageExtension = "image"


// MARK: - User+Avatar

extension User {

    // MARK: - Public Methods

    func updated(with data: Data) throws -> User {
        let relativePath = URL(fileURLWithPath: "/")
            .appendingPathComponent(avatarsFolder)
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(imageExtension)
        let filePath = URL(fileURLWithPath: publicFolder).appendingPathComponent(relativePath.path)

        let avatarsFolder = filePath.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: avatarsFolder.absoluteString) {
            try FileManager.default.createDirectory(at: avatarsFolder, withIntermediateDirectories: true)
        }
        try data.write(to: filePath)

        var copy = self
        copy.avatar = relativePath.path
        return copy
    }

}
