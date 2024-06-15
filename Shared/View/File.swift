//
//  File.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 15/06/2024.
//

import Foundation
import SwiftUI
import Combine

// Your Player class
class Player1: ObservableObject {
  var b: Corvette1
  init(b: Corvette1) {
    self.b = b
  }
}

// Your Corvette struct
struct Corvette1 {
  var c: Int
}

// Your ViewModel class
class ViewModel: ObservableObject {
  @Published var a: Player1
  init(a: Player1) {
    self.a = a
  }
}

// Your SwiftUI view
struct ContentViewa: View {
  @StateObject var viewModel = ViewModel(a: Player1(b: Corvette1(c: 0)))

  var body: some View {
    Stepper(
      "Carriers \(viewModel.a.b.c)",
      value: $viewModel.a.b.c
    )
  }
}
#Preview {
  return ContentViewa()
}
