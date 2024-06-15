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

  @Published var sectorDefenses: Int

  init (attacker: Player,
        defender: Player,
        sectorDefenses: Int) {
    self.sectorDefenses = sectorDefenses
    self.attacker = attacker
    self.defender = defender
    print("init!")
  }

  func combat() {
    let cm = CombatManager(sectorDefenses: sectorDefenses,
                           attacker: attacker,
                           defender: defender)
    cm.combat()
  }
}

struct TechnologyModel: Identifiable {
  var id = UUID()
  var name: String

  init(id: UUID = UUID(), type: TechnologyType) {
    self.id = id
    self.name = type.toString()
  }
}

extension TechnologyType {
  func toString() -> String{
    switch self {
    case .shields:
      "Shields"
    case .shieldsV2:
      "Advanced Shields"
    case .autoDrones:
      "Autonomous Drones"
    case .autoDronesV2:
      "Advanced Autonomous Drones"
    case .destroyersV2:
      "Advanced Destroyers"
    case .deepSpaceMissiles:
      "deepSpaceMissiles"
    case .energyCells:
      "energyCells"
    case .targeting:
      "targeting"
    case .targetingV2:
      "Advanced targeting"
    case .torpedoes:
      "torpedoes"
    case .torpedoesV2:
      "Advanced torpedoes"
    case .deepSpaceMissilesV2oneSY:
      "deepSpaceMissilesV2oneSY"
    case .deepSpaceMissilesV2twoSY:
      "deepSpaceMissilesV2oneSY"
    }
  }
}
