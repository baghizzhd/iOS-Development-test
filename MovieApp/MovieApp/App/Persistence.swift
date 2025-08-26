//
//  Persistence.swift
//  MovieApp
//
//  Created by Baghiz on 26/08/25.
//

import CoreData

struct PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()

    // A container that encapsulates the Core Data stack in our app.
    let container: NSPersistentContainer

    // An initializer to load Core Data, checking for failures.
    init(inMemory: Bool = false) {
        // The name "MovieApp" must match your .xcdatamodeld file name.
        container = NSPersistentContainer(name: "MovieApp")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // This is a serious error that should be handled in a production app.
                // For now, we'll just log it.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Preview Helper
    
    // A static instance specifically for SwiftUI Previews, using an in-memory store.
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create 5 sample movies for the preview
        for i in 0..<5 {
            let newMovie = MovieEntity(context: viewContext)
            newMovie.id = Int64(i)
            newMovie.title = "Sample Movie Title \(i)"
            newMovie.overview = "This is a sample overview for the movie. It provides a brief summary of the plot and characters."
            newMovie.release_date = "2025-08-26"
            newMovie.vote_average = 7.5 + Double(i) * 0.1
            newMovie.vote_count = Int64(1500 + i * 50)
            newMovie.poster_path = "/yvirUYrva23IudARHn3mMGVxWqM.jpg" // Example path
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
