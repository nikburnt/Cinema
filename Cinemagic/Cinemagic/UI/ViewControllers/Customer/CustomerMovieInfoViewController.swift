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
import DateScrollPicker
import GeometricLoaders
import LGButton
import PromiseKit


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

    // swiftlint:disable implicitly_unwrapped_optional
    var movie: PublicMovieWithTicket! { didSet { configure(with: movie) } }


    // MARK: - Private Variables

    private var requireMoviewSetup = false
    private var loader: Infinity?

    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
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
        if movie.hasTicket {
            refoundTicket()
        } else if movie.tickets == 0 {
            // do nothing
        } else {
            claimTicket()
        }
    }


    // MARK: - Private Methods

    private func configure(with movie: PublicMovieWithTicket) {
        guard isViewLoaded else {
            requireMoviewSetup = true
            return
        }

        let placeholderImage = Image(named: "movie-placeholder").require()
        let hidePoster = {
            self.poster.image = placeholderImage
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

        if movie.hasTicket {
            ticketButton.titleString = "Отменить бронирование"
            ticketButton.bgColor = #colorLiteral(red: 0.7764705882, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        } else if movie.tickets == 0 {
            ticketButton.titleString = "Нет билетов"
            ticketButton.bgColor = #colorLiteral(red: 0.2901960784, green: 0.462745098, blue: 0.5882352941, alpha: 1)
        } else {
            ticketButton.titleString = "Забронировать билет"
            ticketButton.bgColor = #colorLiteral(red: 0.2901960784, green: 0.462745098, blue: 0.5882352941, alpha: 1)
        }
    }

    private func setActivity(visible: Bool) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = !visible
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.progressView.alpha = visible ? 1 : 0
            }
        }
    }

    private func claimTicket() {
        self.setActivity(visible: true)
        CinemaDataProvider.shared
            .claimTicket(for: movie)
            .done { self.movie = $0 }
            .catch { self.showError($0) }
            .finally { DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) { self.setActivity(visible: false) } }
    }

    private func refoundTicket() {
        let alert = UIAlertController(title: "Подтверждение",
                                      message: "Вы дествительно хотите отменить бронирование?",
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "Отменить бронь", style: .destructive, handler: { _ in
            self.setActivity(visible: true)
            CinemaDataProvider.shared
                .refoundTicket(for: self.movie)
                .done { self.movie = $0 }
                .catch { self.showError($0) }
                .finally { DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) { self.setActivity(visible: false) } }
        }))
        alert.addAction(.init(title: "Остаивть билет", style: .cancel))

        self.present(alert, animated: true, completion: nil)
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
        alert.addAction(.init(title: "Ок", style: .default))

        self.present(alert, animated: true, completion: nil)
    }

}
