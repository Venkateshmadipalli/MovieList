//
//  ViewController.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 13/05/25.
//


import UIKit
class MoviesViewController: UIViewController, navigateToMoiveDeatiles {
    
    @IBOutlet weak var tableView: UITableView!
    
    let sections = ["Now Playing", "Upcoming", "Top Rated", "Popular"]
    var moviesBySection: [[Movie]] = [[], [], [], []]           // For online data
    var moviesBySection1: [[GalleryDataModel]] = [[], [], [], []] // For local data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        checkInternetAndLoadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieSectionCell", bundle: nil), forCellReuseIdentifier: "MovieSectionCell")
    }
    
    private func checkInternetAndLoadData() {
        if Reachability.isConnectedToNetwork() {
            print("✅ Internet available")
            UserDefaults.standard.set(true, forKey: "Reachability")
            fetchAllMovies()
        } else {
            print("⚠️ No internet connection")
            UserDefaults.standard.set(false, forKey: "Reachability")
            loadLocalMovies()
        }
    }
    
    private func fetchAllMovies() {
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        let endpoints = ["now_playing", "upcoming", "top_rated", "popular"]
        let dispatchGroup = DispatchGroup()
        let localMovieIDs = Set(SGalleryHelper.shared.getAllDataFromScoops().map { $0.id })
        
        for (index, endpoint) in endpoints.enumerated() {
            dispatchGroup.enter()
            MovieService.shared.fetchMovies(endpoint: endpoint) { [weak self] result in
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let movies):
                    self?.moviesBySection[index] = movies
                    
                    for movie in movies where !localMovieIDs.contains(movie.id ?? 0) {
                        self?.saveMovieToLocal(movie: movie, endpoint: endpoint)
                    }
                    
                case .failure(let error):
                    print("Error fetching \(endpoint): \(error)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            LoadingUtils.shared.hideActivityIndicator(uiView: self?.view ?? UIView())
            self?.tableView.reloadData()
        }
    }
    
    private func saveMovieToLocal(movie: Movie, endpoint: String) {
        guard let movieID = movie.id,
              let posterPath = movie.posterPath,
              let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            let baseInfo: [String: Any] = [
                "id": movieID,
                "section": endpoint,
                "overview": movie.overview ?? "",
                "posterPath": data,
                "releaseDate": movie.releaseDate ?? "",
                "voteAverage": movie.voteAverage ?? 0.0,
                "title": movie.title ?? ""
            ]
            
            MovieService.shared.fetchMovie(id: movieID) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let details):
                        let castNames = details.cast?.map { $0.name } ?? []
                        let castingText = "Casting\n" + castNames.joined(separator: "\n")
                        
                        let directors = details.crew?.filter { $0.job.lowercased() == "director" } ?? []
                        let producers = details.crew?.filter { $0.job.lowercased() == "producer" } ?? []
                        
                        let crewText = """
                        Director(s)
                        \(directors.map { $0.name }.joined(separator: "\n"))
                        
                        Producer(s)
                        \(producers.map { $0.name }.joined(separator: "\n"))
                        """
                        
                        let youtubeURLs = details.youtubeTrailers?.compactMap { $0.youtubeURL } ?? []
                        let youtubeInfo: [String: Any] = [
                            "youtube": youtubeURLs.first as Any,
                            "youtube1": youtubeURLs[safe: 1] as Any,
                            "youtube2": youtubeURLs.last as Any,
                            "casting": castingText,
                            "crew": crewText
                        ]
                        
                        let finalData = baseInfo.merging(youtubeInfo) { (_, new) in new }
                        print("finalData",finalData)
                        SGalleryHelper.shared.saveData(galleryInfo: finalData)
                        
                    case .failure(let error):
                        print("Error fetching movie details: \(error)")
                    }
                }
            }
        }.resume()
    }
    
    private func loadLocalMovies() {
        let endpoints = ["now_playing", "upcoming", "top_rated", "popular"]
        let dispatchGroup = DispatchGroup()
        for (index, endpoint) in endpoints.enumerated() {
            dispatchGroup.enter()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let allLocalMovies = SGalleryHelper.shared.getAllDataFromScoops()
                let filtered = allLocalMovies.filter { $0.section == endpoint }
                DispatchQueue.main.async {
                    self?.moviesBySection1[index] = filtered.reversed()
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func navigateToMoiveList(moive: GalleryDataModel) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailVC.movie1 = moive
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func navigateToMoiveList1(moive: Movie) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
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
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSectionCell", for: indexPath) as! MovieSectionCell
        cell.navigateToMoive = self
        
        let isOnline = UserDefaults.standard.bool(forKey: "Reachability")
        if isOnline {
            let movies = moviesBySection[indexPath.section]
            // print("Online section \(indexPath.section): \(movies.count) movies")
            cell.configure(with: movies)
        } else {
            let movies = moviesBySection1[indexPath.section]
            //print("Offline section \(indexPath.section): \(movies.count) movies")
            cell.configure1(with: movies)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor.black
            header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold) // Optional: custom font
            header.contentView.backgroundColor = UIColor.systemGray6 // Optional: background color
        }
    }
}
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
