//
//  ApplicationTests.swift
//  backyardTests
//
//  Created by Nik Burnt on 5/10/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Quick
import Nimble


// MARK: - TestData

private enum TestData {

    static let defaultHost = "127.0.0.1"
    static let defaultLogin = "root"
    static let defaultPassword = ""
    static let defaultDatabase = "cinema"

    static let testHost = "192.168.1.100"
    static let testLogin = "admin"
    static let testPassword = "admin"
    static let testDatabase = "db"

}


// MARK: - Stubs

private class CommandsProcessorStub: CommandsProcessor {

    // MARK: - Public Variables

    private(set) var launchInInteractiveCalled = false
    private(set) var initializationCalled = false
    private(set) var addStaffCalled = false
    private(set) var removeStaffCalled = false

    private(set) var host: String? = nil
    private(set) var login: String? = nil
    private(set) var password: String? = nil
    private(set) var database: String? = nil

    private(set) var email: String? = nil


    // MARK: - CommandsProcessor

    func launchInInteractiveMode() {
        self.launchInInteractiveCalled = true
    }

    func initialize(host: String, login: String, password: String, database: String) {
        self.initializationCalled = true
        self.host = host
        self.login = login
        self.password = password
        self.database = database
    }

    func addStaff(with email: String) {
        self.addStaffCalled = true
        self.email = email
    }

    func removeStaff(with email: String) {
        self.removeStaffCalled = true
        self.email = email
    }


    // MARK: - Public Methods

    func clear() {
        self.launchInInteractiveCalled = false
        self.initializationCalled = false
        self.addStaffCalled = false
        self.removeStaffCalled = false

        self.host = nil
        self.login = nil
        self.password = nil
        self.database = nil

        self.email = nil
    }

}


// MARK: - Tests

class ApplicationTests: QuickSpec {

    // MARK: - Prvate Variables

    private var preTestArguments: [String] = []
    private let processor = CommandsProcessorStub()


    // MARK: - Spec

    override func spec() {

        // MARK: - Application

        describe("Application") {

            // MARK: - Setup

            beforeSuite {
                self.preTestArguments = CommandLine.arguments
            }

            afterSuite {
                CommandLine.arguments = self.preTestArguments
            }

            beforeEach {
                CommandLine.arguments = ["backyard"]
                self.processor.clear()
            }


            // MARK: - Test Cases

            it("should thow an error if wrong arguments provided") {
                CommandLine.arguments.append(contentsOf: ["-a", "test"])

                expect { try Application.run(using: self.processor) }.to(throwError())
            }

            it("should use default start command if command not provided") {
                expect { try Application.run(using: self.processor) }.notTo(throwError())

                expect(self.processor.initializationCalled) == true

                expect(self.processor.launchInInteractiveCalled) == false
                expect(self.processor.addStaffCalled) == false
                expect(self.processor.removeStaffCalled) == false
            }

            it("should call initialization with default values if only start command provided") {
                CommandLine.arguments.append(contentsOf: ["--command", "start"])
                expect { try Application.run(using: self.processor) }.notTo(throwError())

                expect(self.processor.initializationCalled) == true

                expect(self.processor.host) == TestData.defaultHost
                expect(self.processor.login) == TestData.defaultLogin
                expect(self.processor.password) == TestData.defaultPassword
                expect(self.processor.database) == TestData.defaultDatabase
            }

            it("should call initialization with default values if no arguments provided") {
                expect { try Application.run(using: self.processor) }.notTo(throwError())

                expect(self.processor.initializationCalled) == true

                expect(self.processor.host) == TestData.defaultHost
                expect(self.processor.login) == TestData.defaultLogin
                expect(self.processor.password) == TestData.defaultPassword
                expect(self.processor.database) == TestData.defaultDatabase
            }

            it("should not call anything except initialization if no arguments provided") {
                expect { try Application.run(using: self.processor) }.notTo(throwError())

                expect(self.processor.initializationCalled) == true

                expect(self.processor.launchInInteractiveCalled) == false
                expect(self.processor.addStaffCalled) == false
                expect(self.processor.removeStaffCalled) == false
            }

            it("should not call anything except initialization if start command provided") {
                expect { try Application.run(using: self.processor) }.notTo(throwError())

                expect(self.processor.initializationCalled) == true

                expect(self.processor.launchInInteractiveCalled) == false
                expect(self.processor.addStaffCalled) == false
                expect(self.processor.removeStaffCalled) == false
            }

            it("should call initialization with given arguments") {
                let arguments = ["--host", TestData.testHost,
                                 "--login", TestData.testLogin,
                                 "--password", TestData.testPassword,
                                 "--database", TestData.testDatabase]
                CommandLine.arguments.append(contentsOf: arguments)
                expect { try Application.run(using: self.processor) }.notTo(throwError())

                expect(self.processor.initializationCalled) == true

                expect(self.processor.host) == TestData.defaultHost
                expect(self.processor.login) == TestData.defaultLogin
                expect(self.processor.password) == TestData.defaultPassword
                expect(self.processor.database) == TestData.defaultDatabase
            }

            // add user

        }
    }

}
