//
//  BackyardOutput.swift
//  backyard
//
//  Created by Nik Burnt on 5/13/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation

import Rainbow


// MARK: - BackyardOutput

class BackyardOutput: OutputProcessor {

    // MARK: - OutputProcessor Variables

    var appExitRequired: ((_ error: Error?) -> Void)?


    // MARK: - Private Calculated Variables

    private var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        return result
    }()


    // MARK: - OutputProcessor

    func staffList(_ result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            printTable(of: users)
            appExitRequired?(nil)

        case .failure(let error):
            print("An error occurred during obtaining staff list!".lightRed.underline)
            print(error.localizedDescription.bold.lightWhite)
            appExitRequired?(error)
        }
    }

    func addStaff(_ result: Result<User, Error>) {
        // process add staff result
    }

    func removeStaff(_ result: Result<User, Error>) {
        // process remove staff result
    }


    // MARK: - Private Methods

    private func printTable(of users: [User]) {
        print("Staff users list:".underline.bold.white)

        for user in users {
            var userName = user.firstName ?? ""
            if let lastName = user.lastName {
                userName += userName.isEmpty ? lastName : " \(lastName)"
            }

            let email = user.email
            let birthday = dateFormatter.string(from: user.birthday)

            print("\(email)".bold.white)
            print("  name: ".lightWhite.bold + "\(userName.isEmpty ? "-" : userName)".clearColor)
            print("  birthday: ".lightWhite.bold + "\(birthday)\n".clearColor)
        }
    }

}
