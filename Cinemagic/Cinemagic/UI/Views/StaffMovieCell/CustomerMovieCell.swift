//
//  CustomerMovieCell.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/15/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage
import LGButton


// MARK: - CustomerMovieCell

class CustomerMovieCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var startAtLabel: UILabel!
    @IBOutlet private var ticketsLeftLabel: LGButton!


    // MARK: - Public Variables

    var movie: PublicMovieWithTicket? { didSet { configure(with: movie) } }


    // MARK: - Private Variables

    private let dateFormatter: DateFormatter = .dateFormatter(using: " d MMMM")


    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
    }


    // MARK: - Private Methods

    private func configure(with movie: PublicMovieWithTicket?) {
        let placeholderImage = Image(named: "movie-placeholder").require()
        guard let movie = movie else {
            titleLabel.text = nil
            descriptionLabel.text = nil
            startAtLabel.text = nil
            posterImage.image = placeholderImage
            ticketsLeftLabel.titleString = "Билетов нет"
            return
        }

        titleLabel.text = movie.title
        descriptionLabel.text = movie.description
        startAtLabel.text = dateFormatter.string(from: movie.showtime)

        if movie.hasTicket {
            ticketsLeftLabel.titleString = "Вы идёте!"
            ticketsLeftLabel.bgColor = #colorLiteral(red: 0.7764705882, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        } else {
            ticketsLeftLabel.titleString = "Билетов: \(movie.tickets)"
            ticketsLeftLabel.bgColor = #colorLiteral(red: 0.2901960784, green: 0.462745098, blue: 0.5882352941, alpha: 1)
        }

        if let posterUrl = movie.posterUrl {
            posterImage.af_setImage(withURL: posterUrl, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.3))
        } else {
            posterImage.image = placeholderImage
        }
    }

}
