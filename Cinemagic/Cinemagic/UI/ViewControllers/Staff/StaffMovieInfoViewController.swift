//
//  StaffMovieInfoViewController.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage
import AnimatedField
import DateScrollPicker
import GeometricLoaders
import LGButton
import PromiseKit


// MARK: - Private Constants

private let oneLineHeight: CGFloat = 47.333
private let descriptionInitialHeight: CGFloat = 80 - oneLineHeight

private let minimumTitleLength = 1
private let maximumTitleLength = 60
private let minimumDescriptionLength = 12
private let maximumDescriptionLength = 1000


// MARK: - StaffMovieInfoViewController

class StaffMovieInfoViewController: UIViewController,
                                    DateScrollPickerDelegate,
                                    AnimatedFieldDelegate,
                                    UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate {

    // MARK: - Outlets

    @IBOutlet private var contentScrollView: UIScrollView!
    @IBOutlet private var poster: UIImageView!
    @IBOutlet private var selectPosterButton: LGButton!
    @IBOutlet private var titleTextField: AnimatedField!
    @IBOutlet private var descriptionTextField: AnimatedField!
    @IBOutlet private var showtimePicker: DateScrollPicker!
    @IBOutlet private var descriptionHeightConstraint: NSLayoutConstraint!

    @IBOutlet private var deleteButton: UIBarButtonItem!
    @IBOutlet private var saveButton: LGButton!
    @IBOutlet private var saveButtonBottomConstraint: NSLayoutConstraint!

    @IBOutlet private var progressView: UIView!


    // MARK: - Public Variables

    var movie: PublicMovie? { didSet { configure(with: movie) } }


    // MARK: - Private Variables

    // swiftlint:disable implicitly_unwrapped_optional
    private var titleDataSource: AnimatedFieldDataSource!
    private var descriptionDataSource: AnimatedFieldDataSource!
    // swiftlint:enable implicitly_unwrapped_optional

    private var showtime: Date?

    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter
    }()

    private var requireMoviewSetup = false

    private let imagePicker = UIImagePickerController()

    private var newImage: UIImage?

    private var loader: Infinity?


    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        loader = Infinity.createGeometricLoader(progressView)
        loader?.circleColor = #colorLiteral(red: 0.2039215686, green: 0.3294117647, blue: 0.4196078431, alpha: 1)
        loader?.startAnimation()

        let dismissTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissTapGestureRecognizer)

        let selectImageTapGGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPoster(_:)))
        selectImageTapGGestureRecognizer.cancelsTouchesInView = false
        poster.addGestureRecognizer(selectImageTapGGestureRecognizer)
        poster.isUserInteractionEnabled = true

        titleDataSource = CinemaAnimatedTextFieldDataSource(validationRegex: ".{\(minimumTitleLength),\(maximumTitleLength)}",
                                                            validationError: "Название должно быть не пустым и не длиннее \(maximumTitleLength) символов.",
                                                            limit: maximumTitleLength) {
            _ = self.descriptionTextField.becomeFirstResponder()
            let frame = self.contentScrollView.convert(self.descriptionTextField.frame, from: self.descriptionTextField)
            self.contentScrollView.scrollRectToVisible(frame, animated: true)
        }
        titleTextField.setupTitle(with: titleDataSource)

        descriptionDataSource = CinemaAnimatedTextFieldDataSource(validationRegex: ".{\(minimumDescriptionLength),\(maximumDescriptionLength)}",
                                                                  validationError: "Название должно быть не короче \(minimumDescriptionLength) и не длиннее \(maximumDescriptionLength) символов.",
                                                                  limit: maximumDescriptionLength) {
           _ = self.descriptionTextField.resignFirstResponder()
        }
        descriptionTextField.setupDescription(with: descriptionDataSource)
        descriptionTextField.delegate = self

        showtimePicker.delegate = self
        showtimePicker.format = .common

        if requireMoviewSetup {
            configure(with: movie)
        }

        self.imagePicker.delegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    // MARK: - Actions

    @IBAction private func selectPoster(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction private func save(_ sender: Any) {
        guard let title = titleTextField.text, let description = descriptionTextField.text else {
            return
        }

        guard !title.isEmpty else {
            titleTextField.showAlert(titleTextField.dataSource?.animatedFieldValidationError(titleTextField))
            return
        }
        guard !description.isEmpty else {
            descriptionTextField.showAlert(descriptionTextField.dataSource?.animatedFieldValidationError(descriptionTextField))
            return
        }

        guard titleTextField.isValid && descriptionTextField.isValid else { return }

        setActivity(visible: true)
        let promise: Promise<PublicMovie>
        var movieToSend: PublicMovie
        if let movie = movie {
            var copy = movie
            copy.title = title
            copy.description = description
            copy.showtime = showtime ?? Date()
            movieToSend = copy
            promise = CinemaDataProvider.shared.update(movieToSend)
        } else {
            movieToSend = PublicMovie(title: title, description: description, showtime: self.showtime ?? Date())
            promise = CinemaDataProvider.shared.create(movieToSend)
        }

        promise
            .then { movie -> Promise<PublicMovie> in
                movieToSend = movie
                return self.uploadPoster(movie)
            }
            .done { _ in _ = self.navigationController?.popViewController(animated: true) }
            .catch {
                _ = CinemaDataProvider.shared.remove(movieToSend).done { }
                self.showError($0)
            }
            .finally { DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) { self.setActivity(visible: false) } }
    }

    @IBAction private func remove(_ sender: Any) {
        guard let movie = movie else { return }
        let alert = UIAlertController(title: "Подтверждение",
                                      message: "Данный фильм будет удалён из базы без возможности восстановления",
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "Удалить", style: .destructive, handler: { _ in
            self.setActivity(visible: true)
            CinemaDataProvider.shared
                .remove(movie)
                .done { _ = self.navigationController?.popViewController(animated: true) }
                .catch { self.showError($0) }
                .finally { DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) { self.setActivity(visible: false) } }
        }))
        alert.addAction(.init(title: "Отмена", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }


    // MARK: - Keyboard

    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            saveButtonBottomConstraint.constant = 8 + keyboardSize.height - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        saveButtonBottomConstraint.constant = 8
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }


    // MARK: - DateScrollPickerDelegate

    func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, didSelectDate date: Date) {
        showtime = date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
    }


    // MARK: - AnimatedFieldDelegate

    func animatedField(_ animatedField: AnimatedField, didResizeHeight height: CGFloat) {
        descriptionHeightConstraint.constant = descriptionInitialHeight + height
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }

        self.poster.image = image
        self.selectPosterButton.isHidden = true
        self.newImage = image

        self.dismiss(animated: true)
    }


    // MARK: - Private Methods

    private func configure(with movie: PublicMovie?) {
        guard isViewLoaded else {
            requireMoviewSetup = true
            return
        }

        let hidePoster = {
            self.poster.image = nil
            self.selectPosterButton.isHidden = false
        }

        guard let movie = movie else {
            hidePoster()
            self.titleTextField.text = nil
            self.descriptionTextField.text = nil
            self.deleteButton.isEnabled = false
            self.deleteButton.tintColor = .clear
            DispatchQueue.main.async {
                self.showtimePicker.selectToday()
                self.showtime = Date()
            }

            self.saveButton.titleString = "Добавить"
            return
        }

        self.newImage = nil

        if let posterUrl = movie.posterUrl {
            self.poster.af_setImage(withURL: posterUrl) { result in
                if let error = result.error as? AFError, error.responseCode == 404 {
                    hidePoster()
                }
            }
            self.selectPosterButton.isHidden = true
        } else {
            hidePoster()
        }
        self.titleTextField.text = movie.title
        self.descriptionTextField.text = movie.description
        self.showtime = movie.showtime

        DispatchQueue.main.async { self.showtimePicker.selectDate(movie.showtime, animated: false) }

        self.deleteButton.isEnabled = true
        self.deleteButton.tintColor = #colorLiteral(red: 0.0431372549, green: 0.07058823529, blue: 0.09019607843, alpha: 1)
        self.saveButton.titleString = "Сохранить"
    }

    private func setActivity(visible: Bool) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = !visible
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.progressView.alpha = visible ? 1 : 0
            }
        }
    }

    private func showError(_ error: Error) {
        let message: String
        if case NetworkingErrors.movieNotExists = error {
            message = "Такого фильма не существует в базе."
        } else if error is URLError {
            message = "Ошибка соединения с сервером. Проверьте подключение или повторите попытку позже."
        } else {
            message = "Неизвестаня ошибка. Свяжитесь со службой технической поддержки."
        }
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))

        self.present(alert, animated: true, completion: nil)
    }

    private func uploadPoster(_ movie: PublicMovie) -> Promise<PublicMovie> {
        guard let image = newImage else {
            return .value(movie)
        }

        return CinemaDataProvider.shared.upload(movie, poster: image)
    }

}
