//
//  Technology.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 16/06/2024.
//

import Foundation

class TechnologyManager: ObservableObject {
  let technologies: [TechnologyModel] = [
    TechnologyModel(name: "Shields", type: .shields, improved: false),
    TechnologyModel(name: "Autonomous Drones", type: .autoDrones, improved: false),
    TechnologyModel(name: "Deep Space Missiles", type: .deepSpaceMissiles, improved: false),
    TechnologyModel(name: "Energy Cells", type: .energyCells, improved: false),
    TechnologyModel(name: "Targeting", type: .targeting, improved: false),
    TechnologyModel(name: "Torpedoes", type: .torpedoes, improved: false),
    TechnologyModel(name: "Shields", type: .shields, improved: false)
  ]

  let advTechnologies: [TechnologyModel] = [
    TechnologyModel(name: "Impr. Shields", type: .shieldsV2, improved: true),
    TechnologyModel(name: "Impr. Autonomous Drones", type: .autoDronesV2, improved: true),
    TechnologyModel(name: "Impr. Targeting", type: .targetingV2, improved: true),
    TechnologyModel(name: "Impr. Torpedoes", type: .torpedoesV2, improved: true),
    TechnologyModel(name: "Impr. Destroyers", type: .destroyersV2, improved: true)
  ]

  var availableTech: [TechnologyModel] {
    return technologies + advTechnologies.filter{techAssignTable[$0.type]?.isEmpty ?? false }
  }

  //  to quickly access if an adv tech is alread assigned
  private var techAssignTable: [TechnologyType : [Player]] = [:]

  init() {
    for t in technologies + advTechnologies {
      self.techAssignTable[t.type] = []
    }
  }

  func checkTechnology(_ tech: TechnologyType, for player: Player) -> Bool {
    let players = (techAssignTable[tech])
    return players?.contains(where: {$0 === player}) ?? false
  }

//  returns the model of the added technology and register it, nil if it wasnt possible
  func addTechnology(_ tech: TechnologyType, for player: Player) -> TechnologyModel? {
    if let technology = availableTech.first(where: {$0.type == tech}) {
      self.techAssignTable[tech]?.append(player)
      return technology
    }
    return nil
  }
}

struct TechnologyModel: Identifiable, Equatable {
  static func == (lhs: TechnologyModel, rhs: TechnologyModel) -> Bool {
    return lhs.type == rhs.type
  }
  
  var id = UUID()
  var name: String
  var type: TechnologyType
  var improved: Bool

  init(id: UUID = UUID(), name: String, type: TechnologyType, improved: Bool) {
    self.id = id
    self.name = name
    self.type = type
    self.improved = improved
  }
}

enum TechnologyType: String, CaseIterable, Identifiable {
  var id: String { self.rawValue }

  case shields, shieldsV2, autoDrones, autoDronesV2, destroyersV2,
       deepSpaceMissiles, energyCells, targeting, targetingV2, torpedoes, torpedoesV2
}
