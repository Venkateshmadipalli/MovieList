//
//  MovieService.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 13/05/25.
//

import Foundation
class MovieService {
    static let shared = MovieService()
    private let apiKey = "878c76144490b2497ec453a27c739a79"
    private let baseUrl = "https://api.themoviedb.org/3/movie"
    
    func fetchMovies(endpoint: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseUrl)/\(endpoint)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchMovie(id : Int,completion: @escaping (Result<Movie, Error>) -> Void) {
        let urlString = "\(baseUrl)/\(id)?api_key=\(apiKey)&append_to_response=videos,credits"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let movie = try JSONDecoder().decode(Movie.self, from: data)
                    completion(.success(movie))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
