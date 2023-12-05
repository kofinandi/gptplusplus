//
//  GPTPlusPlusApp.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import SwiftUI

@main
struct GPTPlusPlusApp: App {
    let storage: GlobalStorage
    let persistenceController = PersistenceController.shared
    
    init() {
        storage = GlobalStorage()
    }

    var body: some Scene {
        WindowGroup {
            FoldersView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
