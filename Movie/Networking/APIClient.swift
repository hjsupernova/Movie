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
    static let shared = APIClient(apiKey: Bundle.main.apiKey, baseURL: .tmdbAPIBaseURL)
    
    init(apiKey: String, baseURL: URL){
        self.apiKey = apiKey
        self.baseURL = baseURL
    }
    
    func fetchData<T: Decodable>(url: URL, modelType: T.Type) async throws -> T {
        let request = urlRequestFromPath(url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // statusCode 200이 아니면 해당 코드에 맞춰서 에러를 던진다
        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            guard statusCode == 200 else { throw TMDbAPIError(statusCode: statusCode)}
        }
         
        return try parseResponse(data: data, modelType: modelType)
    }
    
}

extension APIClient {
    
    func urlRequestFromPath(_ path: URL) -> URLRequest {
        guard var urlComponents = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
            return URLRequest(url: path)
        }
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = "\(baseURL.path)\(urlComponents.path)"
        
        let url = urlComponents.url!
            .appendingAPIKey(apiKey)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func parseResponse<T: Decodable>(data: Data, modelType: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(modelType, from: data)
            return decodedData
        } catch {
            print("DEBUG: Fetch Data failed: \(error.localizedDescription)")
            throw error
        }
    }
}