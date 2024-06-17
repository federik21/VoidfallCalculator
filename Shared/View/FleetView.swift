//
//  FleetView.swift
//  VoidfallCombat
//
//  Created by federico piccirilli on 15/06/2024.
//

import SwiftUI

struct FleetView: View {
  
  @EnvironmentObject var viewModel: CombatViewModel
  @ObservedObject var player: Player

  var body: some View {
    VStack {
      if player.hasCorvettes {
        Stepper(
          "Corvettes \(player.corvettes.power)",
          value: Binding(
            get: { player.corvettes.power },
            set: { newValue in
              player.corvettes.power = newValue
              // Manually notify observers about the change
              viewModel.objectWillChange.send()
            }
          )
        ).padding(.horizontal)
      } else {
        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
      }

      if player.hasDreadnought {
        Stepper(
          "dreadnoughts \(player.dreadnoughts.power)",
          value: Binding(
            get: { player.dreadnoughts.power },
            set: { newValue in
              player.dreadnoughts.power = newValue
              // Manually notify observers about the change
              viewModel.objectWillChange.send()
            }
          )
        ).padding(.horizontal)
      } else {
        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
      }

      if player.hasDestroyers {
        Stepper(
          "destroyers \(player.destroyers.power)",
          value: Binding(
            get: { player.destroyers.power },
            set: { newValue in
              player.destroyers.power = newValue
              // Manually notify observers about the change
              viewModel.objectWillChange.send()
            }
          )
        ).padding(.horizontal)
      } else {
        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
      }
      if player.hasSentries {
        Stepper(
          "sentries \(player.sentries.power)",
          value: Binding(
            get: { player.sentries.power },
            set: { newValue in
              player.sentries.power = newValue
              // Manually notify observers about the change
              viewModel.objectWillChange.send()
            }
          )
        ).padding(.horizontal)
      } else {
        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
      }
      if player.hasCarrier {
        Stepper(
          "carriers \(player.carriers.power)",
          value: Binding(
            get: { player.carriers.power },
            set: { newValue in
              player.carriers.power = newValue
              // Manually notify observers about the change
              viewModel.objectWillChange.send()
            }
          )).padding(.horizontal)
          Stepper(
            " - Deployable Power \(player.carriers.deployablePower)", value: Binding(
              get: { player.carriers.deployablePower },
              set: { newValue in
                player.carriers.deployablePower = newValue
                // Manually notify observers about the change
                viewModel.objectWillChange.send()
              }
            ), in: 0...15
        ).padding(.horizontal)
      } else {
        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
      }
    }.background(.gray)
  }
}

#Preview {
  let player1 = Player(side: .defender, techManager: TechnologyManager())
  player1.corvettes.power = 1
  return FleetView(player: player1)
}
