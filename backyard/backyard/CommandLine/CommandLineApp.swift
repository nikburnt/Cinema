//
//  CommandLineApp.swift
//  backyard
//
//  Created by Nik Burnt on 5/9/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import ArgumentParser
import Rainbow


// MARK: - Comamnds

private enum Command: String {
    case start
    case listStaff = "list"
    case addStaff = "add"
    case removeStaf = "remove"
}


// MARK: - CommandLineAppErrors

private enum CommandLineAppErrors: Error {
    case emailNotSpecified(command: Command)
}


// MARK: - Private Constants

private let defaultHost = "127.0.0.1"
private let defaultPort = 3306
private let defaultLogin = "root"
private let defaultPassword = ""
private let defaultDatabase = "cinema"
private let defaultCommand = Command.start

extension ArgumentHelp {

    static var host: ArgumentHelp { ArgumentHelp("mysql server host address; default = \(defaultHost)".bold) }
    static var port: ArgumentHelp { ArgumentHelp("mysql server port; default = \(defaultPort)".bold) }
    static var login: ArgumentHelp { ArgumentHelp("login for mysql server; default = \(defaultLogin)".bold) }
    static var password: ArgumentHelp { ArgumentHelp("password for mysql server; default = <empty>".bold) }
    static var database: ArgumentHelp { ArgumentHelp("database name. default = \(defaultDatabase)".bold) }

    static var command: ArgumentHelp { ArgumentHelp(
        "command to execute; default = \(defaultCommand.rawValue)".bold,
        discussion: "Execute one of the following commands:\n"
            + "\t  \(Command.start.rawValue.underline) - starts backyard server with specified parameters\n"
            + "\t \(Command.listStaff.rawValue.underline) - display the staff list\n"
            + "  \(Command.addStaff.rawValue.underline) - add staff user with specified email; the password will be sent by email\n"
            + "  \(Command.removeStaf.rawValue.underline) - remove staff user with specified email"
    ) }

    static var email: ArgumentHelp { ArgumentHelp("user email; used as login".bold) }

}


// MARK: - Application

struct CommandLineApp: ParsableCommand {

    // MARK: - CLI Options

    @Option(help: .host)
    var host: String?

    @Option(help: .port)
    var port: Int?

    @Option(help: .login)
    var login: String?

    @Option(help: .password)
    var password: String?

    @Option(help: .database)
    var database: String?

    @Argument(help: .command)
    var command: String?

    @Argument(help: .email)
    var email: String?


    // MARK: - Private Variables

    // This variable will be setted up during initialization
    // swiftlint:disable implicitly_unwrapped_optional
    private static var processor: CommandsProcessor!


    // MARK: - ParsableCommand

    func run() throws {
        let storage = MySQLDataStorage(host: self.host ?? defaultHost,
                                       port: self.port ?? defaultPort,
                                       login: self.login ?? defaultLogin,
                                       password: self.password ?? defaultPassword,
                                       database: self.database ?? defaultDatabase)
        CommandLineApp.processor.storage = storage

        let command = Command(rawValue: self.command ?? "") ?? Command.start
        switch command {
        case .start:
            CommandLineApp.processor.start()

        case .listStaff:
            CommandLineApp.processor.staffList()

        case .addStaff:
            if let email = self.email {
                CommandLineApp.processor.addStaff(with: email)
            } else {
                throw CommandLineAppErrors.emailNotSpecified(command: command)
            }

        case .removeStaf:
            if let email = self.email {
                CommandLineApp.processor.removeStaff(with: email)
            } else {
                throw CommandLineAppErrors.emailNotSpecified(command: command)
            }
        }
    }


    // MARK: - Public Methods

    static func run(using processor: CommandsProcessor, arguments: [String]? = nil) throws {
        CommandLineApp.processor = processor

        let command = try parseAsRoot(arguments)
        try command.run()
    }

}
