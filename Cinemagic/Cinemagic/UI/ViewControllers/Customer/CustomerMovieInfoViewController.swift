//
//  CustomerMovieInfoViewController.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/15/20.
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

class CustomerMovieInfoViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var contentScrollView: UIScrollView!
    @IBOutlet private var poster: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var showtimeLabel: UILabel!
    @IBOutlet private var ticketButton: LGButton!
    @IBOutlet private var progressView: UIView!


    // MARK: - Public Variables

    var movie: PublicMovie! { didSet { configure(with: movie) } }


    // MARK: - Private Variables

    private var requireMoviewSetup = false
    private var loader: Infinity?

    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter
    }()


    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loader = Infinity.createGeometricLoader(progressView)
        loader?.circleColor = #colorLiteral(red: 0.2039215686, green: 0.3294117647, blue: 0.4196078431, alpha: 1)
        loader?.startAnimation()

        if requireMoviewSetup {
            configure(with: movie)
        }
    }


    // MARK: - Actions

    @IBAction private func ticket(_ sender: Any) {
//        guard let title = titleTextField.text, let description = descriptionTextField.text else {
//            return
//        }
//
//        guard !title.isEmpty else {
//            titleTextField.showAlert(titleTextField.dataSource?.animatedFieldValidationError(titleTextField))
//            return
//        }
//        guard !description.isEmpty else {
//            descriptionTextField.showAlert(descriptionTextField.dataSource?.animatedFieldValidationError(descriptionTextField))
//            return
//        }
//
//        guard titleTextField.isValid && descriptionTextField.isValid else { return }
//
//        setActivity(visible: true)
//        let promise: Promise<PublicMovie>
//        var movieToSend: PublicMovie
//        if let movie = movie {
//            var copy = movie
//            copy.title = title
//            copy.description = description
//            copy.showtime = showtime ?? Date()
//            movieToSend = copy
//            promise = CinemaDataProvider.shared.update(movieToSend)
//        } else {
//            movieToSend = PublicMovie(title: title, description: description, showtime: self.showtime ?? Date())
//            promise = CinemaDataProvider.shared.create(movieToSend)
//        }
//
//        promise
//            .then { movie -> Promise<PublicMovie> in
//                movieToSend = movie
//                return self.uploadPoster(movie)
//            }
//            .done { _ in _ = self.navigationController?.popViewController(animated: true) }
//            .catch {
//                _ = CinemaDataProvider.shared.remove(movieToSend).done { }
//                self.showError($0)
//            }
//            .finally { self.setActivity(visible: false) }
    }


    // MARK: - Private Methods

    private func configure(with movie: PublicMovie) {
        guard isViewLoaded else {
            requireMoviewSetup = true
            return
        }

        let hidePoster = {
            self.poster.image = #imageLiteral(resourceName: "movie-placeholder@3x.png")
        }

        if let posterUrl = movie.posterUrl {
            self.poster.af_setImage(withURL: posterUrl) { result in
                if let error = result.error as? AFError, error.responseCode == 404 {
                    hidePoster()
                }
            }
        } else {
            hidePoster()
        }
        self.titleLabel.text = movie.title
        self.descriptionLabel.text = movie.description
        self.showtimeLabel.text = dateFormatter.string(from: movie.showtime)
    }

//    private func setActivity(visible: Bool) {
//        self.navigationController?.navigationBar.isUserInteractionEnabled = !visible
//        DispatchQueue.main.async {
//            UIView.animate(withDuration: 0.3) {
//                self.progressView.alpha = visible ? 1 : 0
//            }
//        }
//    }
//
//    private func showError(_ error: Error) {
//        let message: String
//        if case NetworkingErrors.movieNotExists = error {
//            message = "Такого фильма не существует в базе."
//        } else if error is URLError {
//            message = "Ошибка соединения с сервером. Проверьте подключение или повторите попытку позже."
//        } else {
//            message = "Неизвестаня ошибка. Свяжитесь со службой технической поддержки."
//        }
//        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
//        alert.addAction(.init(title: "Ok", style: .default))
//
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    private func uploadPoster(_ movie: PublicMovie) -> Promise<PublicMovie> {
//        guard let image = newImage else {
//            return .value(movie)
//        }
//
//        return CinemaDataProvider.shared.upload(movie, poster: image)
//    }

}
