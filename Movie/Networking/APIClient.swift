//
//  APIClient.swift
//  Movie
//
//  Created by KHJ on 2023/10/21.
//

import Foundation
import OSLog

class APIClient {
    private let apiKey: String
    private let baseURL: URL
    static let shared = APIClient(apiKey: Bundle.main.apiKey, baseURL: .tmdbAPIBaseURL)
    #warning("static let 앱에서 계속 살아있음..ㅠ 메모리 ")
    init(apiKey: String, baseURL: URL) {
        self.apiKey = apiKey
        self.baseURL = baseURL
    }

    /// 데이터를 특정 URL에서 불러와서 특정 Model type으로 디코딩 한다.
    /// - Parameters:
    ///   - url: 데이터를 불러올 특정 url path
    ///   - modelType: 불러온 데이터를 디코딩할 모델
    /// - Returns: 지정한 모델로 데이터를 디코딩해 반환한다.
    /// - Throws: HTTP response status code가 200이 아닌 경우 혹은 데이터 파싱에서 오류가 생긴 경우 `TMDbAPIError` 에러 타입을 던진다.
    /// - Note: 이 함수는 비동기 함수이므로 비동기 환경에서 `await` 키워드와 함께 호출되어야 합니다.
    func fetchData<T: Decodable>(url: URL, modelType: T.Type) async throws -> T {
        let request = urlRequestFromPath(url)
        let (data, response) = try await URLSession.shared.data(for: request)
        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            guard statusCode == 200 else { throw TMDbAPIError(statusCode: statusCode) }
        }
        return try parseResponse(data: data, modelType: modelType)
    }
}

extension APIClient {
    private func urlRequestFromPath(_ path: URL) -> URLRequest {
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
    private func parseResponse<T: Decodable>(data: Data, modelType: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(modelType, from: data)
            return decodedData
        } catch {
            Logger.parser.error("DEBUG: Fail to decode data: \(error)")
            throw error
        }
    }
}
