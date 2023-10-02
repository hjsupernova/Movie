//
//  Recommendation.swift
//  Movie
//
//  Created by KHJ on 2023/10/02.
//

import Foundation

struct RecommendationsResponses: Decodable {
    let results: [Recommendation]
}

struct Recommendation: Decodable, Identifiable {
    let title: String
    let id: Int
    let poster_path: String?
    
    
    var posterUrl: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")
        return baseURL?.appending(path: poster_path ?? "")
    }
    
}
