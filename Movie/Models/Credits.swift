//
//  Credits.swift
//  Movie
//
//  Created by KHJ on 2023/10/02.
//

import Foundation

struct Credits: Decodable {
    let id: Int
    let cast: [Cast]
    
    struct Cast: Decodable, Identifiable {
        let id: Int
        let name: String
        let profile_path: String?
        
        var photoUrl: URL? {
            let baseURL = URL(string: "https://image.tmdb.org/t/p/w185")
            return baseURL?.appending(path: profile_path ?? "")
        }
        
        
        static var preview: Cast {
            return Cast(id: 3, name: "Harrison Ford", profile_path: "/5M7oN3sznp99hWYQ9sX0xheswWX.jpg")
        }
    }
}
