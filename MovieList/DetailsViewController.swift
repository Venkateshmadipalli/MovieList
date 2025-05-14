//
//  DetailsViewController.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 14/05/25.
//

import UIKit

class DetailsViewController: UIViewController, FloatRatingViewDelegate {
    var movie: Movie?
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var titelLBL:UILabel!
    @IBOutlet weak var iMG:UIImageView!
    @IBOutlet weak var relaseDataLBL:UILabel!
    @IBOutlet weak var desLBL:UILabel!
    @IBOutlet weak var RattingLBL:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        desLBL.numberOfLines = 0
        titelLBL.text = movie?.title
        relaseDataLBL.text = "Release Date  \(movie?.releaseDate ?? "")"
        desLBL.text = movie?.overview
        configure(with: movie!)
        ratingView.delegate = self
        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        ratingView.type = .halfRatings
        ratingView.rating = movie?.voteAverage ?? 0.0
        RattingLBL.text = "\(movie?.voteAverage ?? 0.0)/10"
        
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    func configure(with movie: Movie) {
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let url = URL(string: baseUrl + (movie.posterPath ?? "")) {
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.iMG.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
