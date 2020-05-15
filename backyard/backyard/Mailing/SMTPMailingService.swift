//
//  SMTPMailingService.swift
//  backyard
//
//  Created by Nik Burnt on 5/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import PromiseKit
import SwiftSMTP


// MARK: - SMTPMailingService

struct SMTPMailingService: MailingService {

    // MARK: - Private Variables

    private let smtp: SMTP
    private let fromUser: Mail.User


    // MARK: - Lifecycle

    init(email: String, password: String) {
        self.smtp = SMTP(hostname: "smtp.gmail.com", email: email, password: password)
        self.fromUser = Mail.User(name: "Cinema", email: email)
    }

    // MARK: - MailingService

    func send(initialPassword password: String, to email: String) -> Promise<Void> {
        let to = Mail.User(email: email)
        let mail = Mail(from: fromUser,
                        to: [to],
                        subject: "Cinema приветствует Вас!",
                        text: """
                            Добро пожаловать в Cinema!
                            Мы создали для Вас временный пароль, вот он: \(password).
                            Пожалуйста, смените его как можно скорее в приложении.
                        """)
        return Promise { seal in
            smtp.send(mail) { seal.resolve($0) }
        }
    }

}
