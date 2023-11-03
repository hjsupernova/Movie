//
//  Credits.swift
//  Movie
//
//  Created by KHJ on 2023/10/02.
//

import Foundation

struct Credits: Decodable {
    let id: Int
    let cast: [CastMember]
}
