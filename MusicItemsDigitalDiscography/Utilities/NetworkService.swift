//
//  NetworkService.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//

import Foundation

class NetworkService {
    func fetchData(from urlString: String) async throws -> Data {
           guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
           let (data, response) = try await URLSession.shared.data(from: url)
           guard let httpResponse = response as? HTTPURLResponse,
                 httpResponse.statusCode == 200 else {
               throw NetworkError.invalidResponse
           }
           return data
       }

    
    enum NetworkError: Error {
        case invalidURL
        case requestFailed(statusCode: Int, message: String)
        case unauthorized(message: String)
        case forbidden(message: String)
        case notFound(message: String)
        case methodNotAllowed(message: String)
        case unprocessableEntity(message: String)
        case internalServerError(message: String)
        case invalidResponse
        case dataError(underlyingError: Error, message: String)
        case decodingError(underlyingError: Error, message: String)
        case noInternetConnection

        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL."
            case .requestFailed(let statusCode, let message):
                return "Request failed with status code \(statusCode): \(message)"
            case .unauthorized(let message):
                return "Unauthorized access: \(message)"
            case .forbidden(let message):
                return "Access to the resource is forbidden: \(message)"
            case .notFound(let message):
                return "The requested resource was not found: \(message)"
            case .methodNotAllowed(let message):
                return "The method is not allowed for the requested URL: \(message)"
            case .unprocessableEntity(let message):
                return "The request was well-formed but was unable to be followed due to semantic errors: \(message)"
            case .internalServerError(let message):
                return "The server encountered an unexpected condition: \(message)"
            case .invalidResponse:
                return "Invalid response from the server."
            case .dataError(_, let message), .decodingError(_, let message):
                return "Data processing error: \(message)"
            case .noInternetConnection:
                return "No internet connection."
            }
        }
    }

}
