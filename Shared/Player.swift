//
//  Player.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation

enum Side: String {
  case invader, defender
}

enum FleetTypes {
  case corvette, carrier, destroyer, dreadnought, sentry
}

class Player: ObservableObject {
  enum Side: String {
    case invader, defender
  }
  var side: Side

  var corvettes: Corvette = Corvette(power: 0)
  var carriers: Carrier = Carrier(power: 0, deployablePower: 0)
  var destroyers: Destroyer = Destroyer()
  var dreadnoughts: Dreadnought = Dreadnought()
  var sentries: Sentry = Sentry()

  var fleets: [Fleet] {
    return [corvettes, carriers, destroyers, dreadnoughts, sentries]
  }

  weak var technologyManager: TechnologyManager?

  var approachAbsorption: Int = 0
  var salvoAbsorption: Int = 0

  var initiative: Int {
    var initiative = 0
    for fleet in fleets {
      // Sentry doesn't add initiative in defense
      guard !(fleet is Sentry && side == .defender) else {
        continue
      }
      initiative += fleet.power
      if ((fleet is Destroyer && side == .invader) || fleet is Dreadnought) && fleet.power > 0 {
        initiative += 1
      }
    }
    if technologyManager?.checkTechnology(.targeting, for: self) ?? false && hasCorvettes {
      // During Combat, if you have any number of Corvette Fleet Power present, gain +5 Initiative
      initiative += 5
    }
    return initiative
  }

  var power: Int {
    var power = 0
    for fleet in fleets {
      power += fleet.power
    }
    return power
  }

  init(side: Side, techManager: TechnologyManager) {
    self.side = side
    self.technologyManager = techManager
  }

  func hasTech (_ tech: TechnologyType) -> Bool {
    return technologyManager?.checkTechnology(tech, for: self) ?? false
  }

  @Published var technologies: [TechnologyModel] = []

  func getTechsToBuy() -> [TechnologyModel] {
    return technologyManager?.availableTech ?? []
  }

  func buyTech(_ tech: TechnologyType) {
    if let technology = technologyManager?.addTechnology(tech, for: self) {
      technologies.append(technology)
    }
  }

  func sufferDamage(on fleetType: FleetTypes) {
    switch fleetType {
    case .corvette:
      corvettes.damage()
    case .carrier:
      carriers.damage()
    case .destroyer:
      destroyers.damage()
    case .dreadnought:
      dreadnoughts.damage()
    case .sentry:
      sentries.damage()
    }
  }

  func getHealtyFleetsTypes() -> [FleetTypes] {
    var fleetTypes: [FleetTypes] = []
    if corvettes.power > 0 {
      fleetTypes.append(.corvette)
    }
    if destroyers.power > 0 {
      fleetTypes.append(.destroyer)
    }
    if carriers.power > 0 {
      fleetTypes.append(.carrier)
    }
    if dreadnoughts.power > 0 {
      fleetTypes.append(.dreadnought)
    }
    if sentries.power > 0 {
      fleetTypes.append(.sentry)
    }
    return fleetTypes
  }
}
// Helpers
extension Player {
  var hasCorvettes:Bool { corvettes.power > 0 }
  var hasDreadnought:Bool { dreadnoughts.power > 0 }
  var hasDestroyers:Bool { destroyers.power > 0 }
  var hasCarrier:Bool { carriers.power > 0 }
  var hasSentries:Bool { sentries.power > 0 }
}
