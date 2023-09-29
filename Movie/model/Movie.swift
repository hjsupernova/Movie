//
//  Movie.swift
//  Movie
//
//  Created by KHJ on 2023/09/11.
//

import Foundation


// MARK: - Response
struct Response: Codable {
    let page: Int
    let results: [Movie]
    let total_pages, total_results: Int
}

// MARK: - Result
struct Movie: Codable, Identifiable {
    let adult: Bool
    let backdrop_path: String?
    let id: Int
    let original_language: String
    let overview: String
    let poster_path: String?
    let release_date, title: String
    let vote_average: Double
    
    //    let originalTitle: String
    //    let popularity: Double
    //    let voteCount: Int
    //    let genreIds: [Int]
    //    let video: Bool
    
    var posterURL: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500/")
        return baseURL?.appending(path: poster_path ?? "")
    }
    var backdropURL: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w1280/")
        return baseURL?.appending(path: backdrop_path ?? "")
    
    }
    
    static var preview: Movie {
        return Movie(adult: false,
                     backdrop_path: "/8pjWz2lt29KyVGoq1mXYu6Br7dE.jpg",
                     id: 615656,
                     original_language: "en",
                     overview: "An exploratory dive into the deepest depths of the ocean of a daring research team spirals into chaos when a malevolent mining operation threatens their mission and forces them into a high-stakes battle for survival.",
                     poster_path: "/4m1Au3YkjqsxF8iwQy0fPYSxE0h.jpg",
                     release_date: "2023-08-02",
                     title: "Meg 2: The Trench",
                     vote_average: 7.0
        )
    }
    
}

