//
//  MovieSectionCell.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 13/05/25.
//

import UIKit

protocol navigateToMoiveDeatiles:AnyObject{
    func navigateToMoiveList(moive:Movie)
    
}

class MovieSectionCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!

    private var movies: [Movie] = []
    weak var navigateToMoive :navigateToMoiveDeatiles?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 230)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
    }
    func configure(with movies: [Movie]) {
        self.movies = movies
        collectionView.reloadData()
    }
}
extension MovieSectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        navigateToMoive?.navigateToMoiveList(moive: selectedMovie)
    }
}

