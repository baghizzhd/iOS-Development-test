//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Baghiz on 26/08/25.
//

import Foundation
import Combine

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastUpdated: Date?

    private let lastUpdatedKey = "MovieApp.lastUpdated.ts" // seconds since 1970

    init() {
        // Restore lastUpdated from timestamp
        let ts = UserDefaults.standard.double(forKey: lastUpdatedKey)
        if ts > 0 {
            self.lastUpdated = Date(timeIntervalSince1970: ts)
        }
    }

    // "today", "yesterday", or "N day ago" (e.g., "2 day ago")
    var lastUpdatedLabel: String {
        guard let date = lastUpdated else { return "not available" }
        let cal = Calendar.autoupdatingCurrent

        if cal.isDateInToday(date) { return "today" }
        if cal.isDateInYesterday(date) { return "yesterday" }

        let startGiven = cal.startOfDay(for: date)
        let startNow   = cal.startOfDay(for: Date())
        let days = cal.dateComponents([.day], from: startGiven, to: startNow).day ?? 0

        // You asked for singular “day” always: "2 day ago"
        return "\(max(days, 2)) day ago"
    }

    // Search filter
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        } else {
            return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func loadMovies() async {
        isLoading = true
        errorMessage = nil

        if isExpiredByOneDay(lastUpdated) {
            await fetchMoviesFromAPI()
        } else {
            let saved = CoreDataManager.shared.fetchMovies()
            if !saved.isEmpty {
                self.movies = saved
            } else {
                await fetchMoviesFromAPI()
            }
        }

        isLoading = false
    }

    private func fetchMoviesFromAPI() async {
        do {
            let fetched = try await APIService.shared.fetchMovies()
            self.movies = fetched
            CoreDataManager.shared.saveMovies(fetched)

            let now = Date()
            self.lastUpdated = now
            UserDefaults.standard.set(now.timeIntervalSince1970, forKey: lastUpdatedKey)
        } catch {
            self.errorMessage = "Failed to load movies from API."
            // Fallback to offline if available
            let saved = CoreDataManager.shared.fetchMovies()
            if !saved.isEmpty { self.movies = saved }
        }
    }

    // Expired if calendar-day difference >= 1
    private func isExpiredByOneDay(_ date: Date?) -> Bool {
        guard let d = date else { return true }
        let cal = Calendar.autoupdatingCurrent
        let startD = cal.startOfDay(for: d)
        let startNow = cal.startOfDay(for: Date())
        let days = cal.dateComponents([.day], from: startD, to: startNow).day ?? 0
        return days >= 1
    }
}
