//
//  GenresEndpoint.swift
//  Movie
//
//  Created by KHJ on 2023/10/21.
//

import Foundation

import URL

enum GenresEndpoint {
    case movie
    case tvSeries
}

extension GenresEndpoint {
    private static let basePath = #URL("/genre")
    var url: URL {
        switch self {
        case .movie:
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingPathComponent("list")
        case .tvSeries:
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingPathComponent("list")
        }
    }
}
