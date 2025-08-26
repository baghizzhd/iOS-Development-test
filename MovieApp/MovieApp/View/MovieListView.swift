//
//  MovieListView.swift
//  MovieApp
//
//  Created by Baghiz on 26/08/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView("Fetching Movies...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.filteredMovies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                MovieRowView(movie: movie)
                            }
                        }

                        // Add a footer for the "Last updated" label
                        Section {
                            if let lastUpdated = viewModel.lastUpdated {
                                Text("Last updated: \(viewModel.lastUpdatedLabel)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                Text("Last updated: Not available")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    .listStyle(PlainListStyle()) // Make sure the list doesn't have extra styling
                }
            }
            .navigationTitle("Popular Movies 🍿")
            .searchable(text: $viewModel.searchText, prompt: "Search for a movie")
            .task {
                // Use .task for async operations tied to the view's lifetime
                if viewModel.movies.isEmpty {
                    await viewModel.loadMovies()
                }
            }
            .refreshable {
                // Allows pull-to-refresh
                await viewModel.loadMovies()
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    MovieListView()
}
