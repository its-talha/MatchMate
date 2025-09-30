//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Mohammad Talha on 27/09/25.
//

import SwiftUI
import CoreData

@main
struct MatchMateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LandingView()
        }
    }
}
