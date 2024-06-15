//combatLog
//  ContentView.swift
//  Shared
//
//  Created by federico piccirilli on 11/11/2022.
//

import SwiftUI

struct ContentView: View {
  // TODO: inject
  @StateObject private var viewModel: CombatViewModel = CombatViewModel(attacker: Player(side: .invader), defender: Player(side: .defender), sectorDefenses: 0)

  @State private var showPopup = false
  @State private var showCombatResult = false
  @State private var activeSide = Side.invader

  var body: some View {
    NavigationView {
      VStack {
        VStack {
          HStack {
            Text("Invader").fontWeight(.heavy)
            Button("+") {
              activeSide = .invader
              showPopup.toggle()
            }
          }
          ScrollView {
            FleetView(player: viewModel.attacker)
          }
          TechnologyView(player: viewModel.attacker)
        }
        VStack {
          HStack {
            Text("Defender").fontWeight(.heavy)
            Button("+") {
              activeSide = .defender
              showPopup.toggle()
            }
          }
          Stepper(
            "Sector Defenses \(viewModel.sectorDefenses)",
            value: $viewModel.sectorDefenses,
            in: 0...3).padding(.horizontal)
          ScrollView {
            FleetView(player: viewModel.defender)
          }
          TechnologyView(player: viewModel.defender)
        }
        Button(action: {
          showCombatResult.toggle()
          viewModel.combat()
        }) {
          Text("Calculate")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
      }
      .navigationBarTitle("Voidfall Combat", displayMode: .inline)
      .sheet(isPresented: $showPopup) {
        TechnologyDialog(showPopup: $showPopup,
                         player: activeSide == .invader ? viewModel.attacker : viewModel.defender)
      }
      // to pass the object to every subview
    }.environmentObject(viewModel)
      .alert(isPresented: $showCombatResult) {
        Alert(
          title: Text("Result"),
          message: Text(viewModel.combatLog),
          dismissButton: .default(Text("OK"))
        )
      }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    return ContentView()
  }
}

struct TechnologyView: View {
  @EnvironmentObject var viewModel: CombatViewModel
  @ObservedObject var player: Player

  var body: some View {
    List {
      Section(header: Text("TECHNOLOGIES")) {
        ForEach(player.getTech()) { tech in
        TechCell(tech: tech).frame(height: 12)
      }}
    }
    .listRowInsets(EdgeInsets())
    .listStyle(.plain)
  }
}
