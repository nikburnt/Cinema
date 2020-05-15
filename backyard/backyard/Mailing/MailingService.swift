//
//  MailingService.swift
//  backyard
//
//  Created by Nik Burnt on 5/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import PromiseKit


// MARK: - MailingService

protocol MailingService {

    func send(initialPassword password: String, to email: String) -> Promise<Void>

}
