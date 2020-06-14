//
//  Movie+Picture.swift
//  backyard
//
//  Created by Nik Burnt on 6/11/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - Private Variables

private let publicFolder = "Public"
private let moviesPicturesFolder = "posters"
private let imageExtension = "image"


// MARK: - Movie+Avatar

extension Movie: PictureUpdate {

    // MARK: - Public Methods

    func updated(with data: Data) throws -> Movie {
        let relativePath = URL(fileURLWithPath: "/")
            .appendingPathComponent(moviesPicturesFolder)
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(imageExtension)
        let filePath = URL(fileURLWithPath: publicFolder).appendingPathComponent(relativePath.path)

        let picturesFolder = filePath.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: picturesFolder.absoluteString) {
            try FileManager.default.createDirectory(at: picturesFolder, withIntermediateDirectories: true)
        }
        try data.write(to: filePath)

        var copy = self
        copy.poster = relativePath.path
        return copy
    }

}
