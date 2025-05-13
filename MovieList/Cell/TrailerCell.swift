//
//  TrailerCell.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 13/05/25.
//

import UIKit

class TrailerCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    func configure(with trailer: MovieVideo) {
//        titleLabel.text = trailer.title
//        if let imageURL = trailer.thumbnailURL {
//            thumbnailImageView.loadImage(from: imageURL)
//        }
    }
}
extension UIImageView {
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
