//
//  SongOrganizerApp.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/15/21.
//

import SwiftUI

@main
struct SongOrganizerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
