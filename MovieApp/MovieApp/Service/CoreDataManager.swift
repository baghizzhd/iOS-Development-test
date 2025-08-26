//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by Baghiz on 26/08/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.persistentContainer = container
    }

    // MARK: - Fetch
    func fetchMovies() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            return results.map { entity in
                Movie(
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    overview: entity.overview ?? "",
                    release_date: entity.release_date ?? "",
                    poster_path: entity.poster_path,
                    vote_average: entity.vote_average,
                    vote_count: Int(entity.vote_count)
                )
            }
        } catch {
            print("Failed to fetch movies from CoreData: \(error)")
            return []
        }
    }

    // MARK: - Save (no duplicate)
    func saveMovies(_ movies: [Movie]) {
        // Menghindari bentrok overload 'perform' dengan Selector
        persistentContainer.performBackgroundTask { context in
            for m in movies {
                let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                request.fetchLimit = 1
                request.predicate = NSPredicate(format: "id == %d", m.id)

                let entity: MovieEntity
                if let existing = ((try? context.fetch(request))?.first) {
                    entity = existing
                } else {
                    entity = MovieEntity(context: context)
                    entity.id = Int64(m.id)
                }

                entity.title = m.title
                entity.overview = m.overview
                entity.release_date = m.release_date
                entity.poster_path = m.poster_path
                entity.vote_average = m.vote_average
                entity.vote_count = Int64(m.vote_count)
            }

            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
