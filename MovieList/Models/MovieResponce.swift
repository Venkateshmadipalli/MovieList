//
//  MovieResponce.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 13/05/25.
//

import Foundation
struct MovieResponse: Codable {
    let results: [Movie]
}
struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    let genres: [MovieGenre]?
    let credits: MovieCredit?
    let videos: MovieVideoResponse?
    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, credits, videos
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case runtime = "runtime"
        case releaseDate = "release_date"
    }
    var genreText: String {
        genres?.first?.name ?? "n/a"
    }
    var ratingText: String {
        let rating = Int(voteAverage.rounded())
        return String(repeating: "★", count: rating)
    }
    var scoreText: String {
        voteAverage > 0 ? String(format: "%.1f/10", voteAverage) : "n/a"
    }
    var cast: [MovieCast]? {
        credits?.cast
    }
    var crew: [MovieCrew]? {
        credits?.crew
    }
    var directors: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }
    var producers: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }
    var screenWriters: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "story" || $0.job.lowercased() == "screenplay" }
    }
    var youtubeTrailers: [MovieVideo]? {
        videos?.results.filter { $0.youtubeURL != nil }
    }
}
struct MovieGenre: Codable {
    let name: String
}
struct MovieCredit: Codable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
}
struct MovieCast: Codable, Identifiable {
    let id: Int
    let character: String
    let name: String
}
struct MovieCrew: Codable, Identifiable {
    let id: Int
    let job: String
    let name: String
}
struct MovieVideoResponse: Codable {
    let results: [MovieVideo]
}
struct MovieVideo: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String

    var youtubeURL: URL? {
        guard site.lowercased() == "youtube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}
enum MovieError: Error {
    case invalidEndpoint
    case apiError
    case invalidResponse
    case noData
    case serializationError
    case networkError
}
