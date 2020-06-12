//
//  StaffMovieCell.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/11/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage


// MARK: - StaffMovieCell

class StaffMovieCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var startAtLabel: UILabel!


    // MARK: - Private Variables

    private let dateFormatter: DateFormatter = .dateFormatter(using: " d MMMM")


    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
    }


    // MARK: - Public Methods

    func configure(with movie: PublicMovie) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.description
        startAtLabel.text = "с \(dateFormatter.string(from: movie.startAt))"

        let placeholderImage = Image(named: "movie-placeholder").require()
        if let posterUrl = movie.posterUrl {
            posterImage.af_setImage(withURL: posterUrl, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.3))
        } else {
            posterImage.image = placeholderImage
        }
    }

}
