//
//  APIClient.swift
//  Movie
//
//  Created by KHJ on 2023/10/21.
//

import Foundation

class APIClient  {
    private let apiKey: String
    private let baseURL: URL

    init(apiKey: String, baseURL: URL){
        self.apiKey = apiKey
        self.baseURL = baseURL
    }
    private func urlFromPath(_ path: URL) -> URL {
        guard var urlComponents = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
            return path
        }
        
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = "\(baseURL.path)\(urlComponents.path)"
        
        return urlComponents.url!
            .appendingAPIKey(apiKey)
    }
    
    func fetchData<T: Decodable>(url: URL, modelType: T.Type) async throws -> T {
        let url = urlFromPath(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(modelType, from: data)
            return decodedData
        } catch {
            print("DEBUG: Fetch Data failed: \(error.localizedDescription)")
            throw error
        }
    }
}
