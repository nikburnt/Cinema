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

        case .failure(_):
            print("An error occurred during obtaining staff list!".lightRed.underline)
        }
    }

    func addStaff(_ result: Result<Void, Error>) {
        switch result {
        case .success:
            print("Staff user registered.".bold.white)

        case .failure(_):
            print("An error occurred during adding staff!".lightRed.underline)
        }
    }

    func removeStaff(_ result: Result<Void, Error>) {
        switch result {
        case .success:
            print("Staff user removed.".bold.white)

        case .failure(_):
            print("An error occurred during removing staff!".lightRed.underline)
        }
    }

    func defaultOutput(_ text: String) {
        print(text)
    }


    // MARK: - Private Methods

    private func printTable(of users: [User]) {
        print("Staff users list:".underline.bold.white)

        for user in users {
            printUser(user)
        }
    }

    private func printUser(_ user: User) {
        var userName = user.firstName ?? ""
        if let lastName = user.lastName {
            userName += userName.isEmpty ? lastName : " \(lastName)"
        }

        let email = user.email
        let birthday: String
        if let date = user.birthday {
            birthday = dateFormatter.string(from: date)
        } else {
            birthday = "-"
        }

        print("\(email)".bold.white)
        print("  name: ".lightWhite.bold + "\(userName.isEmpty ? "-" : userName)".clearColor)
        print("  birthday: ".lightWhite.bold + "\(birthday)\n".clearColor)
    }

}
