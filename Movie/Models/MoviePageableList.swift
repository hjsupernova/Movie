//
//  MoviePageableList.swift
//  Movie
//
//  Created by KHJ on 2023/11/03.
//

import Foundation

struct MoviePageableList: Codable {
    let page: Int
    let results: [Movie]
    let total_pages, total_results: Int
}
