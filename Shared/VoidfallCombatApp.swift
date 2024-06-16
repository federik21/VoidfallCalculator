//
//  VoidfallCombatApp.swift
//  Shared
//
//  Created by federico piccirilli on 11/11/2022.
//

import SwiftUI

@main
struct VoidfallCombatApp: App {

  init() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.purple // Set your desired color
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Title color
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Large title color

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().tintColor = .white // Button color
  }

    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(.dark)
        }
    }
}
