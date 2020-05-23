//
//  SMTPMailingService.swift
//  backyard
//
//  Created by Nik Burnt on 5/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Async
import SwiftSMTP


// MARK: - SMTPMailingService

struct SMTPMailingService: MailingService {

    // MARK: - Private Variables

    private let eventLoopGroup: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 10)

    private let smtp: SMTP
    private let fromUser: Mail.User


    // MARK: - Lifecycle

    init(email: String, password: String) {
        self.smtp = SMTP(hostname: "smtp.gmail.com", email: email, password: password)
        self.fromUser = Mail.User(name: "Cinema", email: email)
    }


    // MARK: - MailingService

    func send(initialPassword password: String, to email: String) -> Future<Void> {
        let subject = "Cinema приветствует Вас!"
        let text = """
            Добро пожаловать в Cinema!
            Мы создали для Вас временный пароль, вот он: \(password)
            Пожалуйста, смените его как можно скорее в приложении.
        """
        return send(subject: subject, text: text, to: email)
    }

    func send(resetPassword password: String, to email: String) -> Future<Void> {
        let subject = "Восстановление пароля Cinema"
        let text = """
            Добрый день, Вы запросили сброс пароля в приложении Cinema.
            Мы создали для Вас временный пароль, вот он: \(password)
            Пожалуйста, смените его как можно скорее в приложении.
        """
        return send(subject: subject, text: text, to: email)
    }


    // MARK: - Private Methods

    private func send(subject: String, text: String, to email: String) -> Future<Void> {
        let to = Mail.User(email: email)
        let mail = Mail(from: fromUser, to: [to], subject: subject, text: text)
        let promise = eventLoopGroup.next().newPromise(of: Void.self)
        smtp.send(mail) { error in
            if let error = error {
                promise.fail(error: error)
            } else {
                promise.succeed()
            }
        }
        return promise.futureResult
    }

}
