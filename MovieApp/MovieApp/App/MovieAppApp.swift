//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Baghiz on 26/08/25.
//

import SwiftUI
import CoreData

@main
struct MovieAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MovieListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
