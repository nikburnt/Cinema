//
//  OutputProcessor.swift
//  backyard
//
//  Created by Nik Burnt on 5/13/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

// MARK: - OutputProcessor

protocol OutputProcessor {

    func staffList(_ result: Result<[User], Error>)
    func addStaff(_ result: Result<Void, Error>)
    func removeStaff(_ result: Result<Void, Error>)

    func defaultOutput(_ text: String)
}
