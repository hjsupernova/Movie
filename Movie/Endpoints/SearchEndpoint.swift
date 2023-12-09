//
//  SearchEndpoint.swift
//  Movie
//
//  Created by KHJ on 2023/10/21.
//

import Foundation

enum SearchEndpoint {
    case movies(query: String, page: Int? = nil)
}

extension SearchEndpoint {
    #warning(" ! 그냥 쓰지마세요.. ")
    static let basePath = URL(string: "/search")!
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
