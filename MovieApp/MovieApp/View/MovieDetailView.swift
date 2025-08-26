//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Baghiz on 26/08/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Poster Image
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                        .frame(height: 500)
                }
                
                // Title and Release Date
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Release Date: \(movie.release_date)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Ratings
                HStack {
                    Label(String(format: "%.1f", movie.vote_average), systemImage: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.title)
                    Spacer()
                    Text("\(movie.vote_count) Votes")
                        .font(.body)
                }
                .foregroundColor(.secondary)

                // Overview
                Text("Overview")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(movie.overview)
                    .font(.body)
                
                // Video Player
                if let videoURL = URL(string: "https://vidsrc.icu/embed/movie/\(movie.id)") {
                    Text("Full Movie Video")
                        .font(.title2)
                        .fontWeight(.semibold)
                    WebView(url: videoURL)
                        .frame(height: 250)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}


// Preview provider
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie(
            id: 12345,
            title: "Sample Movie",
            overview: "This is a sample movie overview.",
            release_date: "2025-08-26",
            poster_path: "/sampleposter.jpg", // Example poster path
            vote_average: 7.8,
            vote_count: 2500
        ))
    }
}
