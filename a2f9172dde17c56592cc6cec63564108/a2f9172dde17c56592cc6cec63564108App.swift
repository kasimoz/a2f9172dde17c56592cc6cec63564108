//
//  a2f9172dde17c56592cc6cec63564108App.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 17.11.2021.
//

import SwiftUI

@main
struct a2f9172dde17c56592cc6cec63564108App: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

