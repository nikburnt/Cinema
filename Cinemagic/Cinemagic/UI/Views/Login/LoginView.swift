//
//  LoginView.swift
//  Cinemagic
//
//  Created by Nik Burnt on 5/29/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import UIKit

import AnimatedField
import GeometricLoaders
import LGButton


// MARK: - LoginView

class LoginView: UIView, NibBasedView {

    // MARK: - Outlets

    @IBOutlet private var emailField: AnimatedField!
    @IBOutlet private var passwordField: AnimatedField!
    @IBOutlet private var loadingView: UIView!
    @IBOutlet private var loginButton: LGButton!


    // MARK: - Public Variables

    var loginHandle: ((String, String) -> Void)?
    var registerHandle: ((String, String) -> Void)?
    var resetHandle: ((String) -> Void)?

    var isLoading: Bool = false { didSet { setLoadingVisible(isLoading) } }

    // MARK: - Private Variables


    // swiftlint:disable implicitly_unwrapped_optional
    private var emailFieldDataSource: AnimatedFieldDataSource!
    private var passwordFieldDataSource: AnimatedFieldDataSource!
    // swiftlint:enable implicitly_unwrapped_optional

    private var loader: WaterWaves?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        clipsToBounds = true
        layer.cornerRadius = 16

        emailFieldDataSource = CinemaAnimatedTextFieldDataSource(validationRegex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,9}",
                                                                 validationError: "Неверный формат адреса электронной почты",
                                                                 limit: 64,
                                                                 nextResponder: passwordField)
        self.emailField.setupEmail(with: emailFieldDataSource)
        self.emailField.text = "nikburnt@gmail.com"

        passwordFieldDataSource = CinemaAnimatedTextFieldDataSource(validationRegex: PasswordStrength.averagePasswordRegex,
                                                                    validationError: "Должен быть 6 символов a-z и как минимум одной цифры",
                                                                    limit: 24) {
            self.login(self.loginButton as Any)
        }
        self.passwordField.setupPassword(with: passwordFieldDataSource)
        self.passwordField.text = "q2w3e4R%"

        loader = WaterWaves.createGeometricLoader(self.loadingView)
        loader?.circleColor = #colorLiteral(red: 0.2039215686, green: 0.3294117647, blue: 0.4196078431, alpha: 1)
        loader?.startAnimation()
    }


    // MARK: - Actions

    @IBAction private func login(_ sender: Any) {
        var somethingMissing = false
        if emailField.text?.isEmpty ?? true {
            somethingMissing = true
            emailField.showAlert("Адрес электронной почты не должен быть пустым.")
        }

        if passwordField.text?.isEmpty ?? true {
            somethingMissing = true
            passwordField.showAlert("Пароль не должен быть пустым.")
        }

        if !somethingMissing && emailField.isValid && passwordField.isValid {
            // Unwrap is safe because validation passed before
            // swiftlint:disable force_unwrapping
            loginHandle?(emailField.text!, passwordField.text!)
        }
    }

    @IBAction private func register(_ sender: Any) {
        var somethingMissing = false
        if emailField.text?.isEmpty ?? true {
            somethingMissing = true
            emailField.showAlert("Адрес электронной почты не должен быть пустым.")
        }

        if passwordField.text?.isEmpty ?? true {
            somethingMissing = true
            passwordField.showAlert("Пароль не должен быть пустым.")
        }

        if !somethingMissing && emailField.isValid && passwordField.isValid {
            // Unwrap is safe because validation passed before
            // swiftlint:disable force_unwrapping
            registerHandle?(emailField.text!, passwordField.text!)
        }
    }

    @IBAction private func restore(_ sender: Any) {
        var somethingMissing = false
        if emailField.text?.isEmpty ?? true {
            somethingMissing = true
            emailField.showAlert("Адрес электронной почты не должен быть пустым.")
        }

        if !somethingMissing && emailField.isValid && passwordField.isValid {
            // Unwrap is safe because validation passed before
            // swiftlint:disable force_unwrapping
            resetHandle?(emailField.text!)
        }
    }


    // MARK: - Private Methods

    private func setLoadingVisible(_ visible: Bool) {
        loadingView.isUserInteractionEnabled = visible
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { self.loadingView.alpha = visible ? 1 : 0 }, completion: { _ in })

    }

}
