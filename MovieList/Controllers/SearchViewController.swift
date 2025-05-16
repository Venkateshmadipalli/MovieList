//
//  SearchViewController.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 15/05/25.
//
import UIKit
class SearchViewController: UIViewController {
    var allItems: [GalleryDataModel] = []
    var filteredItems: [GalleryDataModel] = []
    var movies: [Movie] = []
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var searchTB: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        searchTB.delegate = self
        searchTB.dataSource = self
        searchTB.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        allItems = SGalleryHelper.shared.getAllDataFromScoops()
        filteredItems = []
    }
}
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.bool(forKey: "Reachability") ? movies.count : filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if UserDefaults.standard.bool(forKey: "Reachability"){
            let movie = movies[indexPath.row]
            cell.textLabel?.text = movie.title
            return cell
            
        }else{
            let item = filteredItems[indexPath.row]
            
            
            cell.textLabel?.text = "\(item.title) \(item.releaseDate)"
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDefaults.standard.bool(forKey: "Reachability"){
            let selectedMovie = movies[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController {
                detailVC.movie = selectedMovie
                navigationController?.pushViewController(detailVC, animated: true)
            }
            
        }else{
            let selectedModel = filteredItems[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                detailsVC.movie1 = selectedModel
                print(selectedModel.overview)
                navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItems = []
            movies = []
        } else {
            if UserDefaults.standard.bool(forKey: "Reachability"){
                fetchMovies(query: searchText)
            }else{
                filteredItems = allItems.filter {
                    $0.title.lowercased().contains(searchText.lowercased())
                }
            }
        }
        searchTB.reloadData()
    }
    func fetchMovies(query: String) {
        let apiKey = "ac4a0358d503890486f888521257ded3"
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&region=IN&query=\(query)&language=te-IN&include_adult=false"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.movies = response.results
                    self?.searchTB.reloadData()
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}

