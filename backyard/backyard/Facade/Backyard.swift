//
//  Backyard.swift
//  backyard
//
//  Created by Nik Burnt on 5/13/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import SwiftyBeaver


enum TestError: Error {
    case aaa
}

// MARK: - Backyard

class Backyard: CommandsProcessor {

    // MARK: - CommandsProcessor Variables

    var storage: DataStorage?
    var mailingService: MailingService?


    // MARK: - Private Variables

    var output: OutputProcessor


    // MARK: - Lifecycle

    required init(_ output: OutputProcessor) {
        self.output = output
    }


    // MARK: - CommandsProcessor

    func start() {
        SwiftyBeaver.debug("Server startup requested...")
        // start vapor server, log workflow to console(using logger, not print)
    }

    func staffList() {
        SwiftyBeaver.debug("Staff listing requested...")

        guard let storage = storage else {
            SwiftyBeaver.error("Storage required but not set up. Check if the storage variable set up before this call.")
            return
        }

        storage
            .listOfStaff()
            .done { users in
                SwiftyBeaver.debug("Staff list obtained.", context: users)
                self.output.staffList(.success(users))
            }
            .catch { error in
                SwiftyBeaver.error("Error occured during staff list aquiring: \(error.localizedDescription)", context: error)
                self.output.staffList(.failure(error))
            }
    }

    func addStaff(with email: String) {
        SwiftyBeaver.debug("Adding staff with email \(email) requested...")

        guard let storage = storage else {
            SwiftyBeaver.error("Storage required but not set up. Check if the storage variable set up before this call.")
            return
        }

        guard let mailingService = mailingService else {
            SwiftyBeaver.error("Mailing service required but not set up. Check if the mailingService variable set up before this call.")
            return
        }

        let password = PasswordGenerator.generatePassword()
        storage
            .addStaff(email: email, password: password)
            .done {
                mailingService
                    .send(initialPassword: password, to: email)
                    .done {
                        SwiftyBeaver.debug("Staff user registered.", context: email)
                        self.output.addStaff(.success(()))
                    }
                    .catch { error in
                        SwiftyBeaver.error("Error occured during email with password transmition. Send temp password \(password) to user.", context: error)
                        self.output.addStaff(.failure(error))
                    }
            }
            .catch { error in
                SwiftyBeaver.error("Error occured during staff registration.", context: error)
                self.output.addStaff(.failure(error))
            }
    }

    func removeStaff(with email: String) {
        SwiftyBeaver.debug("Deletion staff with email \(email) requested...")

        guard let storage = storage else {
            SwiftyBeaver.error("Storage required but not set up. Check if the storage variable set up before this call.")
            return
        }

        storage
            .removeStaff(email: email)
            .done {
                SwiftyBeaver.debug("Staff user removed.", context: email)
                self.output.removeStaff(.success(()))
            }
            .catch { error in
                SwiftyBeaver.error("Error occured during staff removing.", context: error)
                self.output.removeStaff(.failure(error))
            }
    }

}
