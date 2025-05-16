//
//  DetailsViewController.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 14/05/25.
//


import UIKit

class DetailsViewController: UIViewController, FloatRatingViewDelegate {
    
    @IBOutlet weak var youtubeTB: UITableView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var titelLBL: UILabel!
    @IBOutlet weak var iMG: UIImageView!
    @IBOutlet weak var relaseDataLBL: UILabel!
    @IBOutlet weak var desLBL: UILabel!
    @IBOutlet weak var RattingLBL: UILabel!
    @IBOutlet weak var castLBL: UILabel!
    @IBOutlet weak var crewLBL: UILabel!
    
    var movie1: GalleryDataModel?
    var movie: Movie?
    var id = 0
    var youtubeArry: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        desLBL.numberOfLines = 0
        ratingView.delegate = self
        ratingView.contentMode = .scaleAspectFit
        ratingView.type = .halfRatings
        
        youtubeTB.delegate = self
        youtubeTB.dataSource = self
        youtubeTB.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        if let movie1 = movie1 {
            configureView(with: movie1)
        } else if let movie = movie {
            configureView(with: movie)
        }
    }
    
    // MARK: - Configure Methods
    
    func configureView(with movie: GalleryDataModel) {
        id = movie.id
        titelLBL.text = movie.title
        relaseDataLBL.text = "Release Date  \(movie.releaseDate ?? "")"
        desLBL.text = movie.overview
        ratingView.rating = movie.voteAverage
        RattingLBL.text = "\(floor(movie.voteAverage * 10) / 10)/10"
        configure1(with: movie)
        
        // Cast
        let fullText = movie.casting
        let attributedText = NSMutableAttributedString(string: fullText)
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(location: 0, length: 7))
        castLBL.numberOfLines = 0
        castLBL.attributedText = attributedText
        
        // Crew
        let fullText1 = movie.crew
        let attributedText1 = NSMutableAttributedString(string: fullText1)
        if let range = fullText1.range(of: "Director(s)") {
            attributedText1.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(range, in: fullText1))
        }
        if let range = fullText1.range(of: "Producer(s)") {
            attributedText1.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(range, in: fullText1))
        }
        crewLBL.numberOfLines = 0
        crewLBL.attributedText = attributedText1
        
        // YouTube
        youtubeArry = [movie.youtube, movie.youtube1, movie.youtube2]
        youtubeTB.reloadData()
    }
    
    func configureView(with movie: Movie) {
        id = movie.id ?? 0
        titelLBL.text = movie.title
        relaseDataLBL.text = "Release Date  \(movie.releaseDate ?? "")"
        desLBL.text = movie.overview
        ratingView.rating = movie.voteAverage
        RattingLBL.text = "\(floor(movie.voteAverage * 10) / 10)/10"
        configure(with: movie)
        
        MovieService.shared.fetchMovie(id: movie.id ?? 0) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fullMovie):
                    self.updateCastAndCrew(for: fullMovie)
                    self.youtubeArry = fullMovie.youtubeTrailers?.compactMap { $0.youtubeURL } ?? []
                    self.youtubeTB.reloadData()
                case .failure(let error):
                    print("Error fetching movie details: \(error)")
                }
            }
        }
    }
    
    func updateCastAndCrew(for movie: Movie) {
        // Cast
        let castNames = movie.cast?.map { $0.name } ?? []
        let fullText = "Casting\n" + castNames.joined(separator: "\n")
        let attributedText = NSMutableAttributedString(string: fullText)
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(location: 0, length: 7))
        castLBL.numberOfLines = 0
        castLBL.attributedText = attributedText
        
        // Crew
        let crewMembers = movie.crew ?? []
        let directors = crewMembers.filter { $0.job.lowercased() == "director" }
        let producers = crewMembers.filter { $0.job.lowercased() == "producer" }
        let fullText1 = "Director(s)\n\(directors.map { $0.name }.joined(separator: "\n"))\n\nProducer(s)\n\(producers.map { $0.name }.joined(separator: "\n"))"
        let attributedText1 = NSMutableAttributedString(string: fullText1)
        if let range = fullText1.range(of: "Director(s)") {
            attributedText1.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(range, in: fullText1))
        }
        if let range = fullText1.range(of: "Producer(s)") {
            attributedText1.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(range, in: fullText1))
        }
        crewLBL.numberOfLines = 0
        crewLBL.attributedText = attributedText1
    }
    
    // MARK: - Configure Image
    
    func configure(with movie: Movie) {
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let url = URL(string: baseUrl + (movie.posterPath ?? "")) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.iMG.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    func configure1(with movie: GalleryDataModel) {
        self.iMG.image = UIImage(data: movie.posterPath)
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView DataSource & Delegate

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Watch Trailer \(indexPath.row + 1)"
        cell.textLabel?.textColor = .systemBlue
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = youtubeArry[indexPath.row]
        handleTrailerSelection(url: url)
    }
}

// MARK: - Online/Offline Handling

extension DetailsViewController {
    
    private func handleTrailerSelection(url: URL) {
        if isConnectedToInternet() {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showNoInternetAlert()
        }
    }
    
    private func isConnectedToInternet() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    private func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your network settings and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
