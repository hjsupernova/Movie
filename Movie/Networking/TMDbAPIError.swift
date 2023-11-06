//
//  TMDbAPIError.swift
//  Movie
//
//  Created by KHJ on 2023/11/06.
//

import Foundation

enum TMDbAPIError: Error, LocalizedError {
    case internalServerError
    case invalidService
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case unknown
    var errorDescription: String? {
        switch self {
            
        case .internalServerError:
            "Internal error: Something went wrong, contact TMDB."
        case .invalidService:
            "Invalid service: this service does not exist."
        case .badGateway:
            "Couldn't connect to the backend server."
        case .serviceUnavailable:
            "The API is undergoing maintenance. Try again later."
        case .gatewayTimeout:
            "Your request to the backend server timed out. Try again."
        case .unknown:
            "Unknwon error happened. Try again later."
        }
    }
}

extension TMDbAPIError {
    init(statusCode: Int) {
        switch statusCode {
        case 500:
            self = .internalServerError
            
        case 501:
            self = .invalidService
            
        case 502:
            self = .badGateway
            
        case 503:
            self = .serviceUnavailable
            
        case 504:
            self = .gatewayTimeout
        default:
            self = .unknown
        }
    }
}
