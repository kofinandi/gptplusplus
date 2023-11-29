//
//  ContentView.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var settings = SettingsViewModel()

    var body: some View {
        SettingsView(settings: settings)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
		
