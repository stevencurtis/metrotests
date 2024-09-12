//
//  TypicodeAlertsApp.swift
//  TypicodeAlerts
//
//  Created by Steven Curtis on 04/09/2024.
//

import SwiftUI

@main
struct TypicodeAlertsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
