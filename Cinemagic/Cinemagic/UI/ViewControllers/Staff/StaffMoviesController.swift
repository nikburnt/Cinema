//
//  StaffMoviesController.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/11/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import UIKit

import AttributedLib
import EmptyDataSet_Swift
import GeometricLoaders


// MARK: - Private Constants

private let cellHeight: CGFloat = 140
private let emptyInfoSpacing: CGFloat = 15
private let emptyInfoOffset: CGFloat = -100

private let movieDetailsSegue = "movieDetails"


// MARK: - StaffMoviesController

class StaffMoviesController: UITableViewController, UISearchResultsUpdating, EmptyDataSetSource, EmptyDataSetDelegate {

    // MARK: - Private Variables

    private var loader: Infinity?

    private var movies: [PublicMovie] = [] { didSet { filter(movies) } }
    private var filteredMovies: [PublicMovie] = [] { didSet { tableView.reloadData() } }

    private let searchController = UISearchController(searchResultsController: nil)

    private var isSearchBarEmpty: Bool { searchController.searchBar.text?.isEmpty ?? true }

    private var lastError: Error?


    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loader = Infinity.createGeometricLoader()
        loader?.circleColor = #colorLiteral(red: 0.2039215686, green: 0.3294117647, blue: 0.4196078431, alpha: 1)

        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Название или описание фильма"
        navigationItem.searchController = searchController

        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.0431372549, green: 0.07058823529, blue: 0.09019607843, alpha: 1)

        updateData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieInfo = segue.destination as? StaffMovieInfoViewController else { return }
        movieInfo.movie = (sender as? StaffMovieCell)?.movie
    }

    // MARK: - Actions

    @IBAction private func logout(_ sender: Any) {
        CinemaDataProvider.shared.logout()
        dismiss(animated: true)
    }

    @IBAction private func addMovie(_ sender: Any) {
        performSegue(withIdentifier: movieDetailsSegue, sender: self)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }


    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StaffMovieCell = tableView.dequeue(for: indexPath).require()
        let data = filteredMovies[indexPath.row]
        cell.movie = data
        return cell
    }


    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        filteredMovies = filtered(movies, using: searchController.searchBar.text ?? "")
    }


    // MARK: - EmptyDataSetDelegate

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        if lastError == nil {
            performSegue(withIdentifier: movieDetailsSegue, sender: self)
        } else {
            updateData()
        }
    }

    func emptyDataSetWillAppear(_ scrollView: UIScrollView) {
        tableView.separatorStyle = .none
    }

    func emptyDataSetWillDisappear(_ scrollView: UIScrollView) {
        tableView.separatorStyle = .singleLine
    }


    // MARK: - EmptyDataSetSource

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title: String
        if lastError != nil {
            title = "Ошибка"
        } else if !isSearchBarEmpty {
            title = "Сожалеем"
        } else {
            title = "Информация"
        }

        let result = title.at.attributed { attributes -> (Attributes) in
            attributes.foreground(color: #colorLiteral(red: 0.0431372549, green: 0.07058823529, blue: 0.09019607843, alpha: 1))
        }
        return result
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title: String
        if lastError != nil {
            title = "Произошла ошибка загрузки данных, проверьте наличие соединения с сетью интернет и повторите попытку."
        } else if !isSearchBarEmpty {
            title = "По данному поисковому запросу нчиего не найдено, попробуйте изменить поисковый запрос."
        } else {
            title = "Пока не добавленно ни одной премьеры, для добавления нажмите '+' вверху или кнопку ниже."
        }

        let result = title.at.attributed { attributes -> (Attributes) in
            attributes.foreground(color: #colorLiteral(red: 0.168627451, green: 0.2745098039, blue: 0.3490196078, alpha: 1))
        }
        return result
    }

    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        let image: UIImage?
        if lastError != nil {
            image = #imageLiteral(resourceName: "reload-button.png")
        } else if isSearchBarEmpty {
            image = #imageLiteral(resourceName: "new-movie-button.png")
        } else {
            image = nil
        }

        return image
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        #colorLiteral(red: 0.9411764706, green: 0.9764705882, blue: 1, alpha: 1)
    }

    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        emptyInfoSpacing
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        emptyInfoOffset
    }

    // MARK: - Private Methods

    private func updateData() {
        setActivity(visible: true)
        loader?.startAnimation()

        CinemaDataProvider.shared
            .moviesList()
            .done {
                self.lastError = nil
                self.movies = $0.sorted { $0.showtime < $1.showtime }
                self.loader?.stopAnimation()
            }
            .catch { self.lastError = $0 }
            .finally {
                self.setActivity(visible: false)
                self.loader?.stopAnimation()
            }
    }

    private func setActivity(visible: Bool) {
        tableView.emptyDataSetView { view in
            view.isUserInteractionEnabled = !visible
            UIView.animate(withDuration: 0.3) {
                view.alpha = visible ? 0 : 1
            }
        }
        tableView.reloadEmptyDataSet()
    }

    private func filter(_ movies: [PublicMovie]) {
        filteredMovies = isSearchBarEmpty ? movies : filtered(movies, using: searchController.searchBar.text ?? "")
    }

    private func filtered(_ movies: [PublicMovie], using search: String) -> [PublicMovie] {
        movies.filter { search.isEmpty || $0.title.lowercased().contains(search.lowercased()) || $0.description.lowercased().contains(search.lowercased()) }
    }

}
