//
//  CombatViewModel.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation
import Combine

class CombatViewModel: ObservableObject {

  @Published var attacker: Player
  @Published var defender: Player

  @Published var sectorDefenses: Int = 0
  @Published var combatLog: String = ""
  
  var combatLogCancellable: AnyCancellable?

  init (technologyManager: TechnologyManager) {
    self.attacker = Player(side: .invader, techManager: technologyManager)
    self.defender = Player(side: .defender, techManager: technologyManager)
  }

  func combat() {
    combatLog = ""
    let cm = CombatManager(sectorDefenses: sectorDefenses,
                           attacker: attacker,
                           defender: defender)
    combatLogCancellable = cm.$logLine.sink{ log in
      self.combatLog.append(log + "\n")
    }
    cm.combat()
    combatLogCancellable = nil
  }
}
