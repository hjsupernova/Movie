//
//  Bundle.swift
//  Moonshot2
//
//  Created by KHJ on 2023/08/01.
//

import Foundation


extension Bundle {
    func decode<T: Codable>(_ file: String) ->  T {
        guard let url = self.url(forResource: file, withExtension: "json") else {
            fatalError("Failed to locate \(file) url")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file)")
        }
        
        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("failed to decode \(file) from bundle")
        }
        
        return loaded
    }
}

