//
//  exchange_ratesApp.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 12/11/2024.
//

import SwiftUI

@main
struct exchange_ratesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
