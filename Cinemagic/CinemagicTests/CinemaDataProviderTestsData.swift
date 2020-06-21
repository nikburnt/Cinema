//
//  File.swift
//  CinemagicTests
//
//  Created by Nik Burnt on 6/21/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation


// MARK: - CinemaDataProviderTestsData

struct CinemaDataProviderTestsData {

    let staffLogin = "nikburnt@gmail.com"
    let staffpartialLogin = "nikburnt"
    let staffPassword = "q2w3e4R%"

    let staffWrongLogin = "admin@admin.com"
    let staffWrongPassword = "mySTRON6password"

    let customerLogin = "nikburnt@gmail.comm"
    let customerPassword = "q2w3e4R%"

    var newUserEmail: String { "random-\(Int.random(in: 0...1_000_000))@mail\(Int.random(in: 0...1_000_000)).com" }
    var newUserWrongEmail = "email.com"
    let newUserPassword = "asdZXC9"
    let newUserWeakPasswordOne = "asdZXC"
    let newUserWeakPasswordTwo = "asdZ9"

}

let testData = CinemaDataProviderTestsData()
