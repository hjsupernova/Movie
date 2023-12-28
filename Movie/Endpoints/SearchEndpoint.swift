//
//  SearchEndpoint.swift
//  Movie
//
//  Created by KHJ on 2023/10/21.
//

import Foundation

import URL

enum SearchEndpoint {
    case movies(query: String, page: Int? = nil)
}

extension SearchEndpoint {
    static let basePath = #URL("/search")
    private enum QueryItemName {
        static let query = "query"
    }
    var url: URL {
        switch self {
        case .movies(let query, let page):
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingQueryItem(name: QueryItemName.query, value: query)
                .appendingPage(page)
        }
    }
}
