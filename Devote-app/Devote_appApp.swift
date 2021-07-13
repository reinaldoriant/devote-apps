//
//  Devote_appApp.swift
//  Devote-app
//
//  Created by TI Digital on 13/07/21.
//

import SwiftUI

@main
struct Devote_appApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
