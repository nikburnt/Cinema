//
//  StaffMoviesController.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/11/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import UIKit

import GeometricLoaders


// MARK: - StaffMoviesController

class StaffMoviesController: UITableViewController {

    // MARK: - Private Variables

    private var loader: Infinity?

    private var movies: [PublicMovie] = [] { didSet { tableView.reloadData() } }


    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loader = Infinity.createGeometricLoader()
        loader?.circleColor = #colorLiteral(red: 0.2039215686, green: 0.3294117647, blue: 0.4196078431, alpha: 1)
        loader?.startAnimation()

        CinemaDataProvider.shared
            .moviesList()
            .done {
                self.movies = $0
                self.loader?.stopAnimation()
            }
            .catch { error in
                print(error)
            }
    }


    // MARK: - Actions

    @IBAction private func logout(_ sender: Any) {
        CinemaDataProvider.shared.logout()
        dismiss(animated: true)
    }


    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StaffMovieCell = tableView.dequeue(for: indexPath).require()
        let data = movies[indexPath.row]
        cell.configure(with: data)
        return cell
    }

}
