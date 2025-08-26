//
//  APIService.swift
//  MovieApp
//
//  Created by Baghiz on 26/08/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

class APIService {
    static let shared = APIService()
    private init() {}

    private let apiKey = "25306eedec9389c60b0d605dcd541415"
    private let baseURL = "https://api.themoviedb.org/3/movie/popular"

    func fetchMovies() async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)?api_key=\(apiKey)&page=1") else {
            throw APIError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                return decodedResponse.results
            } catch {
                throw APIError.decodingError(error)
            }
        } catch {
            throw APIError.requestFailed(error)
        }
    }
}
