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
    
//    func fetchMovie1(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
//
//        guard let url = URL(string: "\(baseUrl)/movie/\(id)") else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
//
//        let params: [String: String] = [
//            "api_key": apiKey,
//            "append_to_response": "videos,credits"
//        ]
//
//        // Use URLSession to make the network request
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
//        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
//
//        let request = URLRequest(url: components.url!)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Network error: \(error)")
//                completion(.failure(.networkError))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.networkError))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let json = try JSONSerialization.jsonObject(with: data)
//
//                print("data",json)
//
//                let movie = try decoder.decode(Movie.self, from: data)
//                completion(.success(movie))
//            } catch {
//                print("Decoding error: \(error)")
//                completion(.failure(.decodingError))
//            }
//        }
//
//        task.resume()
//    }
    
    

}
