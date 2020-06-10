//
//  URLRequest+Networking.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/9/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Alamofire


// MARK: - URLRequest+Networking

extension URLRequest {

    // MARK: - Public Methods

    static func login(email: String, password: String) throws -> URLRequest {
        var request = try URLRequest(url: URL.v1.users.login, method: .post)
        let authenticationData = try "\(email):\(password)".base64()
        request.addValue("Basic \(authenticationData)", forHTTPHeaderField: "Authorization")
        return request
    }

    static func register(email: String, password: String) throws -> URLRequest {
        var request = try URLRequest(url: URL.v1.users.register, method: .post)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"email\":\"\(email)\",\"password\":\"\(password)\"}".data(using: .utf8)
        return request
    }

    static func resetPassword(email: String) throws -> URLRequest {
        var request = try URLRequest(url: URL.v1.users.resetPassword, method: .patch)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"email\":\"\(email)\"}".data(using: .utf8)
        return request
    }

}
