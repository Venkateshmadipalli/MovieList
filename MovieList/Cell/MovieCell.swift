//
//  MovieCell.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 13/05/25.
//

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    func configure(with movie: Movie) {
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let url = URL(string: baseUrl + (movie.posterPath ?? "")) {
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
