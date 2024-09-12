//
//  SimpleAlertsApp.swift
//  SimpleAlerts
//
//  Created by Steven Curtis on 04/09/2024.
//

import SwiftUI

@main
struct SimpleAlertsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
