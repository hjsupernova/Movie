//
//  UserDefaults.swift
//  Movie
//
//  Created by KHJ on 2023/11/24.
//

import Foundation
import OSLog

extension UserDefaults {
    enum UserKeys: String {
        case user
    }

    func saveUser<T: Encodable>(_ data: T?, forKey key: UserKeys) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            set(encodedData, forKey: key.rawValue)
        } catch {
            Logger.userDefaults.error("DEBUG: Failed to Save User to UserDefaults")
        }
    }
    
    func loadUser<T: Decodable>(_ type: T.Type, forKey key: UserKeys) -> T? {
        if let data = data(forKey: key.rawValue) {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(type, from: data)
            } catch {
                Logger.userDefaults.error("DEBUG: Failed to load User from UserDefaults")
            }
        }
        return nil
    }
}
