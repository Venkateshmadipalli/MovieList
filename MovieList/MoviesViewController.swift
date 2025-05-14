//
//  ViewController.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 13/05/25.
//


import UIKit

import UIKit

class MoviesViewController: UIViewController, navigateToMoiveDeatiles {
    @IBOutlet weak var tableView: UITableView!
    
    let sections = ["Now Playing", "Upcoming", "Top Rated", "Popular"]
    var moviesBySection: [[Movie]] = [[], [], [], []] // Array for each section

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchAllMovies()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieSectionCell", bundle: nil), forCellReuseIdentifier: "MovieSectionCell")
    }

    private func fetchAllMovies() {
        let endpoints = ["now_playing", "upcoming", "top_rated", "popular"]
        let dispatchGroup = DispatchGroup()

        for (index, endpoint) in endpoints.enumerated() {
            dispatchGroup.enter()
            MovieService.shared.fetchMovies(endpoint: endpoint) { [weak self] result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let movies):
                    self?.moviesBySection[index] = movies
                case .failure(let error):
                    print("Error fetching \(endpoint): \(error)")
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func navigateToMoiveList(moive: Movie) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailVC.movie = moive
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250 // Adjust as needed for movie poster size
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSectionCell", for: indexPath) as! MovieSectionCell
        cell.navigateToMoive = self
        cell.configure(with: moviesBySection[indexPath.section])
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
}

