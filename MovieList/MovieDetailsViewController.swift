//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 13/05/25.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Properties
    var selectedMovieID: Int?
     var movie: Movie?
    private var trailers: [MovieVideo] = []
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let ratingLabel = UILabel()
    private let runtimeLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let starringLabel = UILabel()
    private let directorLabel = UILabel()
    private let producerLabel = UILabel()
    private let trailersCollectionView: UICollectionView
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        trailersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        if let movie = movie {
            fetchMovieDetails()
        }
    }
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        contentView.addSubview(posterImageView)
        setupLabel(titleLabel, fontSize: 22, fontWeight: .bold, color: .black)
        setupLabel(genreLabel, fontSize: 16, fontWeight: .medium, color: .darkGray)
        setupLabel(descriptionLabel, fontSize: 14, fontWeight: .regular, color: .black, numberOfLines: 0)
        setupLabel(ratingLabel, fontSize: 16, fontWeight: .medium, color: .darkGray)
        setupLabel(runtimeLabel, fontSize: 16, fontWeight: .medium, color: .darkGray)
        setupLabel(releaseDateLabel, fontSize: 16, fontWeight: .medium, color: .darkGray)
        setupLabel(starringLabel, fontSize: 14, fontWeight: .regular, color: .black, numberOfLines: 0)
        setupLabel(directorLabel, fontSize: 14, fontWeight: .regular, color: .black, numberOfLines: 0)
        setupLabel(producerLabel, fontSize: 14, fontWeight: .regular, color: .black, numberOfLines: 0)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(runtimeLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(starringLabel)
        contentView.addSubview(directorLabel)
        contentView.addSubview(producerLabel)
        trailersCollectionView.backgroundColor = .clear
        trailersCollectionView.showsHorizontalScrollIndicator = false
        trailersCollectionView.dataSource = self
        trailersCollectionView.delegate = self
        trailersCollectionView.register(TrailerCell.self, forCellWithReuseIdentifier: "TrailerCell")
        contentView.addSubview(trailersCollectionView)
    }
    private func setupLabel(_ label: UILabel, fontSize: CGFloat, fontWeight: UIFont.Weight, color: UIColor, numberOfLines: Int = 1) {
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.textColor = color
        label.numberOfLines = numberOfLines
    }
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        runtimeLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        starringLabel.translatesAutoresizingMaskIntoConstraints = false
        directorLabel.translatesAutoresizingMaskIntoConstraints = false
        producerLabel.translatesAutoresizingMaskIntoConstraints = false
        trailersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            posterImageView.heightAnchor.constraint(equalToConstant: 250),
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        NSLayoutConstraint.activate([
            trailersCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            trailersCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trailersCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trailersCollectionView.heightAnchor.constraint(equalToConstant: 150),
            trailersCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    private func fetchMovieDetails() {
        guard let movieID = movie?.id else { return }
        
        MovieAPI.shared.fetchMovie(id: movieID) { result in
            switch result {
            case .success(let movie):
                print("Fetched movie: \(movie.title)")
                self.movie = movie
                self.updateUI(with: movie)
            case .failure(let error):
                print("Failed to fetch movie: \(error)")
            }
        }
        
    }
    
    private func updateUI(with movie: Movie) {
         let posterPath = movie.posterPath
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            // Assuming you have a method to load images from a URL
            posterImageView.loadImage(from: url)
        } else {
            posterImageView.image = UIImage(named: "placeholder") // Fallback image
        }
        
//        // Update the labels with the fetched data
//        titleLabel.text = movie.title
//        genreLabel.text = movie.genres?.map { $0.name }.joined(separator: ", ") ?? "N/A"
//        descriptionLabel.text = movie.overview
//        ratingLabel.text = "Rating: \(movie.rating)"
//        runtimeLabel.text = "Runtime: \(movie.runtime.map { "\($0) minutes" } ?? "N/A")"
//        releaseDateLabel.text = "Release Date: \(movie.releaseDate ?? "N/A")"
//
//        // Cast, Director, and Producer
//        let castNames = movie.credits.cast.map { $0.name }.joined(separator: ", ")
//        starringLabel.text = "Starring: \(castNames.isEmpty ? "N/A" : castNames)"
//
//        let director = movie.credits.directors.first?.name ?? "N/A"
//        directorLabel.text = "Director: \(director)"
//
//        let producer = movie.credits.producers.first?.name ?? "N/A"
//        producerLabel.text = "Producer: \(producer)"
//
//        // Update trailers collection view if there are trailers
//        if !movie.videos.trailers.isEmpty {
//            self.trailers = movie.videos.trailers
//            trailersCollectionView.reloadData()
//        }
    }

}

// MARK: - Collection View Data Source and Delegate
extension MovieDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trailers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrailerCell", for: indexPath) as! TrailerCell
        let trailer = trailers[indexPath.item]
        cell.configure(with: trailer)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 150)
    }
}
