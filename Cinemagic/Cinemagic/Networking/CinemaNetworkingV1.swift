//
//  CinemaNetworkingV1.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/6/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation

import Alamofire
import PromiseKit


// MARK: - NetworkingErrors

enum NetworkingErrors: Error {
    case authenticationError
    case movieNotExists
    case imageCantBeconvertedToPNG
    case userNotExists
    case userAlreadyExists
    case unexpectedError
    case unknownError(Int)
}


// MARK: - HTTPResponseStatus

// swiftlint:disable identifier_name
enum HTTPResponseStatus: Int {
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case expectationFailed = 417
}


// MARK: - CinemaNetworkingV1

class CinemaNetworkingV1 {

    // MARK: - Authentication

    func login(email: String, password: String) -> Promise<PublicToken> {
        firstly { Promise<URLRequest>.value(try URLRequest.login(email: email, password: password)) }
            .then { Alamofire.request($0).responseData() }
            .map { try JSONDecoder.decode($0.data) }
    }

    func register(email: String, password: String) -> Promise<PublicToken> {
        firstly { Promise<URLRequest>.value(try URLRequest.register(email: email, password: password)) }
            .then { Alamofire.request($0).responseData() }
            .map { alamofireDataResponse -> PublicToken in
                guard let statusCodeInteger = alamofireDataResponse.response.response?.statusCode else { throw NetworkingErrors.unexpectedError }
                guard let statusCode = HTTPResponseStatus(rawValue: statusCodeInteger) else { throw NetworkingErrors.unknownError(statusCodeInteger) }

                guard statusCode != .conflict else { throw NetworkingErrors.userAlreadyExists }
                guard statusCode == .ok else { throw NetworkingErrors.unknownError(statusCodeInteger) }

                let tokenResponse: PublicToken = try JSONDecoder.decode(alamofireDataResponse.data)
                return tokenResponse
            }
    }

    func resetPassword(email: String) -> Promise<Void> {
        firstly { Promise<URLRequest>.value(try URLRequest.resetPassword(email: email)) }
            .then { Alamofire.request($0).responseData() }
            .map { alamofireDataResponse -> Void in
                guard let statusCodeInteger = alamofireDataResponse.response.response?.statusCode else { throw NetworkingErrors.unexpectedError }
                guard let statusCode = HTTPResponseStatus(rawValue: statusCodeInteger) else { throw NetworkingErrors.unknownError(statusCodeInteger) }

                guard statusCode != .notFound else { throw NetworkingErrors.userNotExists }
                guard statusCode == .ok else { throw NetworkingErrors.unknownError(statusCodeInteger) }

                return ()
            }
    }


    // MARK: - Users

    func currentUser(_ bearer: String) -> Promise<PublicUser> {
        firstly { Promise<URLRequest>.value(try URLRequest.currentUser(bearer: bearer)) }
            .then { Alamofire.request($0).responseData() }
            .map { try JSONDecoder.decode($0.data) }
    }


    // MARK: - Movies

    func allMovies(_ bearer: String) -> Promise<[PublicMovie]> {
        firstly { Promise<URLRequest>.value(try URLRequest.allMovies(bearer: bearer)) }
            .then { Alamofire.request($0).responseData() }
            .map { try JSONDecoder.decode($0.data) }
    }

    func update(_ movie: PublicMovie, bearer: String) -> Promise<PublicMovie> {
        firstly { Promise<URLRequest>.value(try URLRequest.update(movie, bearer: bearer)) }
            .then { Alamofire.request($0).responseData() }
            .map { alamofireDataResponse -> PublicMovie in
                guard let statusCodeInteger = alamofireDataResponse.response.response?.statusCode else { throw NetworkingErrors.unexpectedError }
                guard let statusCode = HTTPResponseStatus(rawValue: statusCodeInteger) else { throw NetworkingErrors.unknownError(statusCodeInteger) }

                guard statusCode != .notFound else { throw NetworkingErrors.movieNotExists }
                guard statusCode == .ok else { throw NetworkingErrors.unknownError(statusCodeInteger) }

                let tokenResponse: PublicMovie = try JSONDecoder.decode(alamofireDataResponse.data)
                return tokenResponse
            }
    }

    func create(_ movie: PublicMovie, bearer: String) -> Promise<PublicMovie> {
        firstly { Promise<URLRequest>.value(try URLRequest.create(movie, bearer: bearer)) }
            .then { Alamofire.request($0).responseData() }
            .map { alamofireDataResponse -> PublicMovie in
                guard let statusCodeInteger = alamofireDataResponse.response.response?.statusCode else { throw NetworkingErrors.unexpectedError }
                guard let statusCode = HTTPResponseStatus(rawValue: statusCodeInteger) else { throw NetworkingErrors.unknownError(statusCodeInteger) }
                guard statusCode == .ok else { throw NetworkingErrors.unknownError(statusCodeInteger) }

                let tokenResponse: PublicMovie = try JSONDecoder.decode(alamofireDataResponse.data)
                return tokenResponse
            }
    }

    func upload(_ movie: PublicMovie, poster: UIImage, bearer: String) -> Promise<PublicMovie> {
        guard let imageDate = poster.pngData() else {
            return .init(error: NetworkingErrors.imageCantBeconvertedToPNG)
        }
        return firstly { Promise<URLRequest>.value(try URLRequest.upload(movie, bearer: bearer)) }
            .then { Alamofire.upload(imageDate, with: $0).responseData() }
            .map { alamofireDataResponse -> PublicMovie in
                guard let statusCodeInteger = alamofireDataResponse.response.response?.statusCode else { throw NetworkingErrors.unexpectedError }
                guard let statusCode = HTTPResponseStatus(rawValue: statusCodeInteger) else { throw NetworkingErrors.unknownError(statusCodeInteger) }
                guard statusCode == .ok else { throw NetworkingErrors.unknownError(statusCodeInteger) }

                let tokenResponse: PublicMovie = try JSONDecoder.decode(alamofireDataResponse.data)
                return tokenResponse
            }
    }

    func remove(_ movie: PublicMovie, bearer: String) -> Promise<Void> {
        firstly { Promise<URLRequest>.value(try URLRequest.remove(movie, bearer: bearer)) }
            .then { Alamofire.request($0).responseData() }
            .map { alamofireDataResponse -> Void in
                guard let statusCodeInteger = alamofireDataResponse.response.response?.statusCode else { throw NetworkingErrors.unexpectedError }
                guard let statusCode = HTTPResponseStatus(rawValue: statusCodeInteger) else { throw NetworkingErrors.unknownError(statusCodeInteger) }

                guard statusCode != .notFound else { throw NetworkingErrors.movieNotExists }
                guard statusCode == .ok else { throw NetworkingErrors.unknownError(statusCodeInteger) }

                return ()
            }
    }


    // MARK: - Movies With Tickets

    func allMoviesWithTickets(bearer: String) -> Promise<[PublicMovieWithTicket]> {
        firstly { Promise<URLRequest>.value(try URLRequest.allMoviesWithTickets(bearer: bearer)) }
            .then { Alamofire.request($0).responseData() }
            .map { try JSONDecoder.decode($0.data) }
    }

    func claimTicket(for movie: PublicMovieWithTicket, bearer: String) -> Promise<PublicMovieWithTicket> {
        firstly { Promise<URLRequest>.value(try URLRequest.claimTicket(for: movie, bearer: bearer)) }
            .then { Alamofire.request($0).responseData() }
            .map { try JSONDecoder.decode($0.data) }
    }

    func refoundTicket(for movie: PublicMovieWithTicket, bearer: String) -> Promise<PublicMovieWithTicket> {
        firstly { Promise<URLRequest>.value(try URLRequest.refoundTicket(for: movie, bearer: bearer)) }
            .then { Alamofire.request($0).responseData() }
            .map { try JSONDecoder.decode($0.data) }
    }

}
