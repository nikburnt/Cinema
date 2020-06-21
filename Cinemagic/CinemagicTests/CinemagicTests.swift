//
//  CinemagicTests.swift
//  CinemagicTests
//
//  Created by Nik Burnt on 5/28/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

@testable
import Cinemagic

import Quick
import Nimble
import PromiseKit



// MARK: - Tests

class CinemaDataProviderTests: QuickSpec {

    // MARK: - Spec

    override func spec() {
        beforeSuite {
            Nimble.AsyncDefaults.Timeout = 5
        }

        describe("Login") {
            it("should authenticate existing user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .done { done()  }
                        .catch { fail("User not logged in with correct email and password: \($0)") }
                }
            }

            it("should not authenticate not existing user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffWrongLogin, password: testData.staffPassword)
                        .done { fail("User should not be logged in if it doesn't exists.")  }
                        .catch { _ in done() }
                }
            }

            it("should not authenticate user with incorrect login format") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffWrongPassword)
                        .done { fail("User should not be logged in with incorrect login format(not email).")  }
                        .catch { _ in done() }
                }
            }

            it("should not authenticate user with wrong password") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffWrongPassword)
                        .done { fail("User should not be logged in using wrong password.")  }
                        .catch { _ in done() }
                }
            }
        }

        describe("Register") {
            it("should register new user if email and password pass validation") {
                waitUntil { done in
                    let email = testData.newUserEmail
                    CinemaDataProvider.shared
                        .register(email: email, password: testData.newUserPassword)
                        .then { CinemaDataProvider.shared.login(email: email, password: testData.newUserPassword) }
                        .done { done()  }
                        .catch { fail("User was not registered with correct email and password: \($0)") }
                }
            }

            it("should not register user with duplicate email") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .register(email: testData.staffLogin, password: testData.newUserPassword)
                        .then { CinemaDataProvider.shared.login(email: testData.staffLogin, password: testData.newUserPassword) }
                        .done { fail("User should not be registered with existing email.")  }
                        .catch { _ in done() }
                }
            }

            it("should not register user with invalid email") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .register(email: testData.newUserWrongEmail, password: testData.newUserPassword)
                        .then { CinemaDataProvider.shared.login(email: testData.newUserWrongEmail, password: testData.newUserPassword) }
                        .done { fail("User should not be registered with existing email.")  }
                        .catch { _ in done() }
                }
            }

            it("should not register user with too short password") {
                waitUntil { done in
                    let email = testData.newUserEmail
                    CinemaDataProvider.shared
                        .register(email: email, password: testData.newUserWeakPasswordTwo)
                        .then { CinemaDataProvider.shared.login(email: email, password: testData.newUserWeakPasswordTwo) }
                        .done { fail("User should not be registered with too short password.")  }
                        .catch { _ in done() }
                }
            }

            it("should not register user with too weak password") {
                waitUntil { done in
                    let email = testData.newUserEmail
                    CinemaDataProvider.shared
                        .register(email: testData.newUserEmail, password: testData.newUserWeakPasswordOne)
                        .then { CinemaDataProvider.shared.login(email: email, password: testData.newUserWeakPasswordOne) }
                        .done { fail("User should not be registered with too weak password.")  }
                        .catch { _ in done() }
                }
            }
        }

        describe("Reset Password") {
            it("should be completed successful if valid existing user email provided") {
                waitUntil(timeout: 5) { done in
                    let email = testData.newUserEmail
                    CinemaDataProvider.shared
                        .register(email: email, password: testData.newUserPassword)
                        .then { CinemaDataProvider.shared.login(email: email, password: testData.newUserPassword) }
                        .then { CinemaDataProvider.shared.resetPassword(email: email) }
                        .then { CinemaDataProvider.shared.login(email: email, password: testData.newUserPassword) }
                        .done { fail("User should not be able to login with previous password after reset.")  }
                        .catch { _ in done() }
                }
            }

            it("should not be completed successful if user with tis email does not exist") {
                waitUntil(timeout: 5) { done in
                    CinemaDataProvider.shared
                        .resetPassword(email: testData.newUserEmail)
                        .done { fail("User should not be able to reset password for not existing user.")  }
                        .catch { _ in done() }
                }
            }
        }

        describe("Curren User") {
            it("should obtain current user data for staff user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.currentUser() }
                        .done { user in
                            expect(user.email) == testData.staffLogin
                            expect(user.role) == .staff
                            done()
                        }
                        .catch { fail("Current user should be obtained sucessful: \($0)")}
                }
            }

            it("should obtain current user data for customer user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.currentUser() }
                        .done { user in
                            expect(user.email) == testData.customerLogin
                            expect(user.role) == .customer
                            done()
                        }
                        .catch { fail("Current user should be obtained sucessful: \($0)")}
                }
            }

            it("should refresh token if it is expired on obtaining current user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { () -> Promise<PublicUser> in
                            CinemaKeychain().tokenExpirationDate = Date.distantPast
                            return CinemaDataProvider.shared.currentUser()
                        }
                        .done { user in
                            expect(user.email) == testData.staffLogin
                            expect(user.role) == .staff
                            done()
                        }
                        .catch { fail("Current user should be obtained sucessful: \($0)")}
                }
            }

            it("should not refresh token if it is expired but password changed") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { () -> Promise<PublicUser> in
                            CinemaKeychain().tokenExpirationDate = Date.distantPast
                            CinemaKeychain().password = testData.staffWrongPassword
                            return CinemaDataProvider.shared.currentUser()
                        }
                        .done { _ in fail("Should not refresh token if user password was changed.")
                        }
                        .catch { f_ in done() }
                }
            }

            it("should not obtain current user data if user not logged in") {
                waitUntil { done in
                    CinemaDataProvider.shared.logout()
                    CinemaDataProvider.shared
                        .currentUser()
                        .done { _ in fail("User should not be obtained if user not logged in.") }
                        .catch { _ in done() }
                }
            }
        }

        describe("Staff Movies") {

            var newMovieId: Int?

            it("should be obtained for staff user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.moviesList() }
                        .done { movies in
                            expect(movies) == PublicMovie.defaultMovies
                            done()
                        }
                        .catch { fail("Movies should be obtained successful for staff user: \($0).") }
                }
            }

            it("should not be obtained for customer user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.moviesList() }
                        .done { _ in fail("Movies should not be obtained for customer user type.") }
                        .catch { _ in done() }
                }
            }

            it("should not be obtained for not logged in user") {
                waitUntil { done in
                    CinemaDataProvider.shared.logout()
                    CinemaDataProvider.shared
                        .moviesList()
                        .done { _ in fail("Movies should not be obtained for not logged in user.") }
                        .catch { _ in done() }
                }
            }

            it("should provide creation of new movie for staff user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.create(.newMovie) }
                        .done { movie in
                            newMovieId = movie.id
                            expect(newMovieId).notTo(beNil())
                            expect(movie) ~= PublicMovie.newMovie
                            done()
                        }
                        .catch { fail("Movie should be successfully created : \($0).") }
                }
            }

            it("should not create movie for customer user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.create(.newMovie) }
                        .done { _ in fail("Movie should not be create by customer.")}
                        .catch { _ in done() }
                }
            }

            it("should not create movie with invalid title") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.create(.newMovieInvalidOne) }
                        .done { _ in fail("Movie should not be create when title is invalid.")}
                        .catch { _ in done() }
                    }
            }

            it("should not create movie with invalid description") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.create(.newMovieInvalidTwo) }
                        .done { _ in fail("Movie should not be create when title is invalid.")}
                        .catch { _ in done() }
                    }
            }

            it("should not create movie for unauthenticated user") {
                waitUntil { done in
                    CinemaDataProvider.shared.logout()
                    CinemaDataProvider.shared
                        .create(.newMovie)
                        .done { _ in fail("Movie should not be create by unauthenticated user.") }
                        .catch { _ in done() }
                }
            }

            it("should update movie for staff user") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdated(id: newMovieId!)
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.update(updatedMovie) }
                        .done { movie in
                            expect(movie) == updatedMovie
                            done()
                        }
                        .catch { fail("Movie should be successfully updated : \($0).") }
                }
            }

            it("should not update movie for customer user") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdated(id: newMovieId!)
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.update(updatedMovie) }
                        .done { _ in fail("Movie should not be updated by customer.")}
                        .catch { _ in done() }
                }
            }

            it("should not update movie with wrong id") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdatedInvalidOne(id: 0)
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.update(updatedMovie) }
                        .done { _ in fail("Movie should not be updated when id is wrong.")}
                        .catch { _ in done() }
                    }
            }

            it("should not update movie with invalid title") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdatedInvalidOne(id: newMovieId!)
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.update(updatedMovie) }
                        .done { _ in fail("Movie should not be updated when title is invalid.")}
                        .catch { _ in done() }
                    }
            }

            it("should not update movie with invalid description") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdatedInvalidTwo(id: newMovieId!)
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.update(updatedMovie) }
                        .done { _ in fail("Movie should not be updated when title is invalid.")}
                        .catch { _ in done() }
                    }
            }

            it("should not update movie for unauthenticated user") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdated(id: newMovieId!)
                    CinemaDataProvider.shared.logout()
                    CinemaDataProvider.shared
                        .update(updatedMovie)
                        .done { _ in fail("Movie should not be updated by unauthenticated user.") }
                        .catch { _ in done() }
                }
            }

            it("should upload movie poster for staff user") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdated(id: newMovieId!)
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.upload(updatedMovie, poster: UIImage(systemName: "house")!) }
                        .done { movie in
                            expect(movie) ~= updatedMovie
                            expect(movie.poster).notTo(beNil())
                            done()
                        }
                        .catch { fail("Movie should be successfully updated : \($0).") }
                }
            }

            it("should not upload movie poster for customer user") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdated(id: newMovieId!)
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.upload(updatedMovie, poster: UIImage(systemName: "house")!) }
                        .done { _ in fail("Poster should not be uploaded by customer user.") }
                        .catch { _ in done() }
                }
            }

            it("should not upload movie poster for unauthenticated user") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdated(id: newMovieId!)
                    CinemaDataProvider.shared.logout()
                    CinemaDataProvider.shared
                        .upload(updatedMovie, poster: UIImage(systemName: "house")!)
                        .done { _ in fail("Poster should not be uploaded by unauthenticated user.") }
                        .catch { _ in done() }
                }
            }

            it("should not delete movie for customer user") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdated(id: newMovieId!)
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.remove(updatedMovie) }
                        .done { _ in fail("Movie should not be removed by customer.")}
                        .catch { _ in done() }
                }
            }

            it("should not delete movie for unauthenticated user") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdated(id: newMovieId!)
                    CinemaDataProvider.shared.logout()
                    CinemaDataProvider.shared
                        .remove(updatedMovie)
                        .done { _ in fail("Movie should not be removed by unauthenticated user.") }
                        .catch { _ in done() }
                }
            }

            it("should delete movie for staff user") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdated(id: newMovieId!)
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.remove(updatedMovie) }
                        .done { done() }
                        .catch { fail("Movie should be successfully deleted : \($0).") }
                }
            }

            it("should not delete already deleted or not existing movie") {
                waitUntil { done in
                    expect(newMovieId).notTo(beNil())
                    let updatedMovie = PublicMovie.newMovieUpdated(id: newMovieId!)
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.remove(updatedMovie) }
                        .done { fail("Movie should not be deleted successful if already deleted or not exists.") }
                        .catch { _ in done() }
                }
            }


        }

        describe("Tickets") {
            it("should provide list of movies with tickets for staff user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.moviesWithTicketsList() }
                        .done { movies in
                            expect(movies.sorted { $0.showtime < $1.showtime }) == PublicMovieWithTicket.defaultMovies.sorted { $0.showtime < $1.showtime }
                            done()
                        }
                        .catch { fail("Movies with tickets should be available for staff user : \($0).") }
                }
            }

            it("should provide list of movies with tickets for customer user") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.moviesWithTicketsList() }
                        .done { movies in
                            expect(movies.sorted { $0.showtime < $1.showtime }) == PublicMovieWithTicket.defaultMovies.sorted { $0.showtime < $1.showtime }
                            done()
                        }
                        .catch { fail("Movies with tickets should be available for customer user : \($0).") }
                }
            }

            it("should not provide list of movies with tickets for unauthorized user") {
                waitUntil { done in
                    CinemaDataProvider.shared.logout()
                    CinemaDataProvider.shared
                        .moviesWithTicketsList()
                        .done { _ in fail("Movies with tickets should not be available for unauthorized user.") }
                        .catch { _ in done() }
                }
            }

            it("should be available for cutomer to claim ticket") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.claimTicket(for: PublicMovieWithTicket.defaultMovies[0]) }
                        .done { movie in
                            expect(movie) ~= PublicMovieWithTicket.defaultMovies[0]
                            expect(movie.hasTicket).to(beTrue())
                            done()
                        }
                        .catch { fail("Ticket should be claimed: \($0).") }
                }
            }

            it("should not be available for cutomer to claim ticket for unexisting movie") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.claimTicket(for: PublicMovieWithTicket.unexistingMovie) }
                        .done { _ in fail("Ticket should not be claimed for unexisting movie.") }
                        .catch { _ in done() }
                }
            }

            it("should not be available for cutomer to claim ticket if all tickets already claimed") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.claimTicket(for: PublicMovieWithTicket.movieWithoutTickets) }
                        .done { _ in fail("Ticket should not be claimed for if all tickets claimed.") }
                        .catch { _ in done() }
                }
            }

            it("should be available for cutomer to refound ticket") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.refoundTicket(for: PublicMovieWithTicket.defaultMovies[0]) }
                        .done { movie in
                            expect(movie) ~= PublicMovieWithTicket.defaultMovies[0]
                            expect(movie.hasTicket).to(beFalse())
                            done()
                        }
                        .catch { fail("Ticket should be refounded: \($0).") }
                }
            }

            it("should not be available to refound unclaimed ticket") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.customerLogin, password: testData.customerPassword)
                        .then { CinemaDataProvider.shared.refoundTicket(for: PublicMovieWithTicket.defaultMovies[0]) }
                        .done { _ in fail("Ticket should not refound not claimed ticket.") }
                        .catch { _ in done() }
                }
            }


            it("should be available for staff to claim ticket") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.claimTicket(for: PublicMovieWithTicket.defaultMovies[0]) }
                        .done { movie in
                            expect(movie) ~= PublicMovieWithTicket.defaultMovies[0]
                            expect(movie.hasTicket).to(beTrue())
                            done()
                        }
                        .catch { fail("Ticket should be claimed: \($0).") }
                }
            }

            it("should be available for staff to refound ticket") {
                waitUntil { done in
                    CinemaDataProvider.shared
                        .login(email: testData.staffLogin, password: testData.staffPassword)
                        .then { CinemaDataProvider.shared.refoundTicket(for: PublicMovieWithTicket.defaultMovies[0]) }
                        .done { movie in
                            expect(movie) ~= PublicMovieWithTicket.defaultMovies[0]
                            expect(movie.hasTicket).to(beFalse())
                            done()
                        }
                        .catch { fail("Ticket should be refounded: \($0).") }
                }
            }

            it("should not be available for unauthorized user to claim ticket") {
                waitUntil { done in
                    CinemaDataProvider.shared.logout()
                    CinemaDataProvider.shared
                        .claimTicket(for: PublicMovieWithTicket.defaultMovies[0])
                        .done { _ in fail("Should not claim ticket for unauthorized user.") }
                        .catch { _ in done() }
                }
            }

            it("should not be available for unauthorized user to refound ticket") {
                waitUntil { done in
                CinemaDataProvider.shared.logout()
                    CinemaDataProvider.shared
                        .refoundTicket(for: PublicMovieWithTicket.defaultMovies[0])
                        .done { _ in fail("Should not refound ticket for unauthorized user.") }
                        .catch { _ in done() }
                }
            }

        }
    }

}
