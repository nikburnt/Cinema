//
//  Application.swift
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
    case addStaff
    case removeStaf
}


// MARK: - Private Constants

private let defaultHost = "127.0.0.1"
private let defaultLogin = "root"
private let defaultPassword = ""
private let defaultCommand = Command.start

extension ArgumentHelp {

    static var interactiveMode: ArgumentHelp { ArgumentHelp(
        "launch the app with an interactive command-line interface".bold,
        discussion: "We heavily suggest using this mode in the production against using login/password arguments".lightYellow
    ) }

    static var host: ArgumentHelp { ArgumentHelp("mysql server host address; default = \(defaultHost)".bold) }

    static var login: ArgumentHelp { ArgumentHelp(
        "login for mysql server; default = \(defaultLogin)".bold,
        discussion: "Only for test and debug purpose, never use this way of initialization in production".lightRed.underline
    ) }

    static var password: ArgumentHelp { ArgumentHelp(
        "password for mysql server; default = <empty>".bold,
        discussion: "Only for test and debug purpose, never use this way of initialization in production".lightRed.underline
    ) }

    static var database: ArgumentHelp { ArgumentHelp("database name. default = cinema".bold) }

    static var command: ArgumentHelp { ArgumentHelp(
        "command to execute; default = \(defaultCommand.rawValue)".bold,
        discussion: "Execute one of the following commands:\n"
            + "\t  \(Command.start.rawValue.underline) - starts backyard server with specified parameters\n"
            + "  \(Command.addStaff.rawValue.underline) - add staff user with specified email; the password will be sent by email\n"
            + "  \(Command.removeStaf.rawValue.underline) - remove staff user with specified email; confirmation will be required"
    ) }

    static var email: ArgumentHelp { ArgumentHelp("user email; used as login".bold) }

}


// MARK: - Application

struct Application: ParsableCommand {

    // MARK: - CLI Options

    @Flag(help: .interactiveMode)
    var interactiveMode: Bool

    @Option(help: .host)
    var host: String?

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

    private static var processor: CommandsProcessor?


    // MARK: - ParsableCommand

    func run() throws {
        // TODO: - Process parsed command
    }

    
    // MARK: - Public Methods

    static func run(using processor: CommandsProcessor, arguments: [String]? = nil) -> Never {
        self.processor = processor
        Application.main(arguments)
    }

}
