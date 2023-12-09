//
//  URL.swift
//  Movie
//
//  Created by KHJ on 2023/10/21.
//

import Foundation

// MARK: - BaseURL

extension URL {
    static var tmdbAPIBaseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }
}

// MARK: - Path + QueryItem appending functions

extension URL {
    /// Int 타입의 path component를 추가 (기본 메소드는 String 타입만을 받는다.)
    func appendingPathComponent(_ value: Int) -> Self {
        appendingPathComponent(String(value))
    }
    func appendingQueryItem(name: String, value: CustomStringConvertible) -> Self {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value.description))
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}

extension URL {
    private enum QueryItemName {
        static let apiKey = "api_key"
        static let language = "language"
        static let page = "page"
    }
    func appendingAPIKey(_ apiKey: String) -> Self {
        appendingQueryItem(name: QueryItemName.apiKey, value: apiKey)
    }
    func appendingPage(_ page: Int?) -> Self {
        guard var page = page else {
            return self
        }
        page = max(page, 1)
        page = min(page, 1000)
        return appendingQueryItem(name: QueryItemName.page, value: page)
    }
    func appendingLanguage(_ languageCode: String?) -> Self {
        guard let languageCode else {
            return self
        }
        return appendingQueryItem(name: QueryItemName.language, value: languageCode)
    }
}
