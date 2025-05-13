//
//  MovieAPI.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 13/05/25.
//

import Foundation
class MovieAPI {
    static let shared = MovieAPI()

    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let apiKey = "878c76144490b2497ec453a27c739a79" // Replace with your API key
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    
    // Helper function for making API requests and decoding responses
     func loadURLAndDecode<D: Decodable>(
        url: URL,
        params: [String: String]? = nil,
        completion: @escaping (Result<D, MovieError>) -> ()
    ) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Network error: \(error)")
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                print("Decoding error: \(error)")
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    // Helper to execute completion handlers on the main thread
    private func executeCompletionHandlerInMainThread<D>(
        with result: Result<D, MovieError>,
        completion: @escaping (Result<D, MovieError>) -> ()
    ) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadURLAndDecode(
            url: url,
            params: ["append_to_response": "videos,credits"],
            completion: completion
        )
    }
}


