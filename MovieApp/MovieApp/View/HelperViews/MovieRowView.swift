//
//  MovieRowView.swift
//  MovieApp
//
//  Created by Baghiz on 26/08/25.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 15) {
            // Movie Poster
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
                    .overlay(ProgressView())
            }
            
            VStack(alignment: .leading, spacing: 5) {
                // Movie Title
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                // Release Date
                Text("Release: \(movie.release_date)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Movie Rating
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text("\(movie.vote_average, specifier: "%.1f")")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct MovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample movie data for preview, ensuring all required properties are passed
        MovieRowView(movie: Movie(id: 1,
                                  title: "Inception",
                                  overview: "A thief who steals corporate secrets through the use of dream-sharing technology...",
                                  release_date: "2010-07-16",
                                  poster_path: "/kqjL17yufvn9OVp5A3mMw4cHxbJ.jpg",
                                  vote_average: 8.8,
                                  vote_count: 27000))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
