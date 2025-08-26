//
//  Movie.swift
//  MovieApp
//
//  Created by Baghiz on 26/08/25.
//

import Foundation

// MARK: - Main response structure from the API
struct MovieResponse: Codable {
    let results: [Movie]
}

// MARK: - Movie data structure
// Conforms to Codable for JSON decoding and Identifiable for SwiftUI lists.
struct Movie: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let release_date: String
    let poster_path: String?
    let vote_average: Double
    let vote_count: Int
    
    // Computed properties for constructing full image URLs
    var posterURL: URL? {
        guard let path = poster_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
