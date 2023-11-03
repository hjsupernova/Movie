//
//  CastMember.swift
//  Movie
//
//  Created by KHJ on 2023/11/03.
//

import Foundation

struct CastMember: Decodable, Identifiable {
    let id: Int
    let name: String
    let profile_path: String?
    
    var photoUrl: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w185")
        return baseURL?.appending(path: profile_path ?? "")
    }
    
    
    static var preview: CastMember {
        return CastMember(id: 3, name: "Harrison Ford", profile_path: "/5M7oN3sznp99hWYQ9sX0xheswWX.jpg")
    }
}
