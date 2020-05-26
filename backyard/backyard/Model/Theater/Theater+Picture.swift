//
//  Theater+Picture.swift
//  backyard
//
//  Created by Nik Burnt on 5/25/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Vapor


// MARK: - Private Variables

private let publicFolder = "Public"
private let theatersPicturesFolder = "theaters"
private let imageExtension = "image"


// MARK: - User+Avatar

extension Theater {

    // MARK: - Public Methods

    func updated(with data: Data) throws -> Theater {
        let relativePath = URL(fileURLWithPath: "/")
            .appendingPathComponent(theatersPicturesFolder)
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(imageExtension)
        let filePath = URL(fileURLWithPath: publicFolder).appendingPathComponent(relativePath.path)

        let picturesFolder = filePath.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: picturesFolder.absoluteString) {
            try FileManager.default.createDirectory(at: picturesFolder, withIntermediateDirectories: true)
        }
        try data.write(to: filePath)

        var copy = self
        copy.picture = relativePath.path
        return copy
    }

}
