//
//  LoadingViewController.swift
//  Cinemagic
//
//  Created by Nik Burnt on 5/28/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation
import UIKit

import Alamofire
import GeometricLoaders
import GradientAnimator
import PromiseKit
import SwiftEntryKit


// MARK: - Private Constants

private let goToMainStaffSegue = "goToMainStaff"
private let goToMainCustomerSegue = "goToMainCustomer"


// MARK: - LoadingViewController

class LoadingViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var activityContainer: UIView!


    // MARK: - Private Variables

    private var loader: BlinkingCircles?


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientView = GradientAnimator(frame: self.view.frame,
                                            theme: GradientThemes.SolidStone,
                                            _startPoint: GradientPoints.bottomLeft,
                                            _endPoint: GradientPoints.topRight,
                                            _animationDuration: 3.0)
        view.insertSubview(gradientView, at: 0)
        gradientView.startAnimate()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if loader == nil {
            loader = BlinkingCircles.createGeometricLoader(self.activityContainer)
            loader?.circleColor = .white
        }

        loader?.startAnimation()

        EKAttributes.Precedence.QueueingHeuristic.value = .chronological

        goToMain()
    }


    // MARK: - Private Methods

    private func goToMain() {
        SwiftEntryKit.dismiss()

        CinemaDataProvider.shared
            .currentUser()
            .done { self.performSegue(withIdentifier: $0.role == .staff ? goToMainStaffSegue : goToMainCustomerSegue, sender: nil) }
            .catch { _ in self.showLogin() }
    }

    private func showLogin() {
        guard let loginView = LoginView.instantiateFromNib() else {
            // log
            return
        }

        loginView.loginHandle = { email, password in
            loginView.isLoading = true
            CinemaDataProvider.shared
                .login(email: email, password: password)
                .done { self.goToMain() }
                .catch { self.showLoginError($0) }
                .finally { loginView.isLoading = false }
        }

        loginView.registerHandle = { email, password in
            loginView.isLoading = true
            CinemaDataProvider.shared
                .register(email: email, password: password)
                .done { self.goToMain() }
                .catch { self.showRegistrationError($0) }
                .finally { loginView.isLoading = false }
        }

        loginView.resetHandle = { email in
            loginView.isLoading = true
            CinemaDataProvider.shared
                .resetPassword(email: email)
                .done { self.showPasswordResetted() }
                .catch { self.showPasswordResetError($0) }
                .finally { loginView.isLoading = false }
        }

        loginView.showAsAuthentication()
    }

    private func showLoginError(_ error: Error) {
        let message = error is URLError ? "Ошибка соединения с сервером. Проверьте подключение или повторите попытку позже." : "Логин и/или пароль не верные."
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ок", style: .default))

        let presentedViewController = SwiftEntryKit.window?.rootViewController ?? self
        presentedViewController.present(alert, animated: true, completion: nil)
    }

    private func showRegistrationError(_ error: Error) {
        let message: String
        if case NetworkingErrors.userAlreadyExists = error {
            message = "Пользователь с таким адресом электронной почты уже зарегистрирован."
        } else if error is URLError {
            message = "Ошибка соединения с сервером. Проверьте подключение или повторите попытку позже."
        } else {
            message = "Неизвестаня ошибка. Свяжитесь со службой технической поддержки."
        }
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ок", style: .default))

        let presentedViewController = SwiftEntryKit.window?.rootViewController ?? self
        presentedViewController.present(alert, animated: true, completion: nil)
    }

    private func showPasswordResetted() {
        let alert = UIAlertController(title: "Информация", message: "На указанную Вами почту был отправлен новый пароль для входа.", preferredStyle: .alert)
        alert.addAction(.init(title: "Ок", style: .default))

        let presentedViewController = SwiftEntryKit.window?.rootViewController ?? self
        presentedViewController.present(alert, animated: true, completion: nil)
    }

    private func showPasswordResetError(_ error: Error) {
        let message: String
        if error is URLError {
            message = "Ошибка соединения с сервером. Проверьте подключение или повторите попытку позже."
        } else if case NetworkingErrors.userNotExists = error {
            message = "Пользователя с указанным адресом электронной почты не существует."
        } else {
            message = "Неизвестаня ошибка. Свяжитесь со службой технической поддержки."
        }
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ок", style: .default))

        let presentedViewController = SwiftEntryKit.window?.rootViewController ?? self
        presentedViewController.present(alert, animated: true, completion: nil)
    }

}
