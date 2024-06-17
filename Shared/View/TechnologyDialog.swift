//
//  TechnologyDialog.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 14/06/2024.
//

import SwiftUI

struct TechnologyDialog: View {

  @Binding var showPopup: Bool

  // I don't need to recreate the vm in this detail, so no stateObject
  //  @ObservedObject var viewModel: CombatViewModel
  
  @EnvironmentObject var viewModel: CombatViewModel
  @ObservedObject var player: Player

  var body: some View {
    NavigationView {
      List {
        Section(header: Text("FLEETS")) {
          if !player.hasCorvettes {
            Button("corvette") {
              player.corvettes.power += 1
              viewModel.objectWillChange.send() 
              showPopup = false
            }
          }
          if !player.hasDestroyers {
            Button("destroyers") {
              player.destroyers.power += 1
              viewModel.objectWillChange.send()
              showPopup = false
            }
          }
          if !player.hasDreadnought {
            Button("dreadnoughts") {
              player.dreadnoughts.power += 1
              viewModel.objectWillChange.send()
              showPopup = false
            }
          }
          if !player.hasSentries {
            Button("sentries") {
              player.sentries.power += 1
              viewModel.objectWillChange.send()
              showPopup = false
            }
          }
          if !player.hasCarrier {
            Button("carriers") {
              player.carriers.power += 1
              viewModel.objectWillChange.send()
              showPopup = false
            }
          }
        }
        Section(header: Text("TECHNOLOGIES")) {
          ForEach(player.getTechsToBuy()) { tech in
            // Only show tech the player hasn't added yet
            if !player.hasTech(tech.type) {
              Button(tech.name) {
                player.buyTech(tech.type)
                viewModel.objectWillChange.send()
                showPopup = false
              }
            }
          }
        }
      }
      .navigationBarTitle("Items", displayMode: .inline)
      .navigationBarItems(trailing: Button("Close") {
        showPopup = false
      })
    }
  }
}


#Preview {
  let player1 = Player(side: .defender, techManager: TechnologyManager())
  player1.corvettes.power = 1
  return TechnologyDialog(showPopup: .constant(true), player: player1)
}
