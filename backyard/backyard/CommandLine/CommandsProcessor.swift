//
//  CommandsProcessor.swift
//  backyard
//
//  Created by Nik Burnt on 5/10/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

// MARK: - CommandsProcessor

protocol CommandsProcessor {

    var storage: DataStorage? { get set }

    init(_ output: OutputProcessor)

    func start()
    func staffList()
    func addStaff(with email: String)
    func removeStaff(with email: String)

}
