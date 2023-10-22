//
//  FileManger.swift
//  Movie
//
//  Created by KHJ on 2023/10/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
