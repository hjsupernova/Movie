//
//  MoviesEndpoint.swift
//  Movie
//
//  Created by KHJ on 2023/10/21.
//

import Foundation


enum MoviesEndpoint {
    case popular(page: Int? = nil)
    case upcoming(page: Int? = nil)
    case recommendations(movieID: Movie.ID, page: Int? = nil)
    case credits(movieID: Movie.ID)
    case nowplaying(page: Int? = nil)
}

extension MoviesEndpoint {
    
    private static let basePath = URL(string: "/movie")!
    var url: URL  {
        switch self {
        case .popular(let page):
            return Self.basePath
                .appending(path: "popular")
                .appendingPage(page)
        case .upcoming(let page):
            return Self.basePath
                .appendingPathComponent("upcoming")
                .appendingPage(page)
        case .recommendations(let movieID, let page):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("recommendations")
                .appendingPage(page)
        case .credits(movieID: let movieID):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("credits")
                
        case .nowplaying(page: let page):
            return Self.basePath
                .appending(path: "now_playing")
                .appendingPage(page)
        }
    }
}
