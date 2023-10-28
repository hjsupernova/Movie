//
//  Bundle.swift
//  Moonshot2
//
//  Created by KHJ on 2023/08/01.
//

import Foundation

//MARK: - JSON File
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


//MARK: - API KEY 
extension Bundle {
    
    var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "SecureAPIKeys", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file 'SecureAPIKeys.plist'.")
        }
        
        guard let value = plistDict.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_Key' in 'SecureAPIKeys.plist'.")
        }
        return value
    }
}
