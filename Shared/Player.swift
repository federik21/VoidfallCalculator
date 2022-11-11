//
//  Player.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation

enum Technology {
  case shields, shieldsV2, autoDrones, autoDronesV2
}

enum Side {
  case invader, defender
}

enum FleetTypes {
  case corvette, carrier
}

class Player {
  var corvettes: Corvette = Corvette(power: 0)
  var carriers: Carrier = Carrier(power: 0, deployablePower: 0)

  var fleets: [Fleet] {
    return [corvettes, carriers]
  }
  var technologies: [Technology] = []
  var side: Side

  var approachAbsorption: Int = 0
  var salvoAbsorption: Int = 0

  var initiative: Int {
    var initiative = 0
    for fleet in fleets {
      initiative += fleet.initiative
    }
    return initiative
  }
  var power: Int {
    var power = 0
    for fleet in fleets {
      power += fleet.power
    }
    return initiative
  }

  init(side: Side) {
    self.side = side
  }

  func enterApproachStep() {
    if corvettes.power > 0 && technologies.contains(.shieldsV2) {
      print("Improved shields will absorb 1 approach damage")
      approachAbsorption += 1
    }
    if side == .invader, technologies.contains(.autoDrones), technologies.contains(.autoDronesV2) {
      print("Autonomous drones will absorb 1 approach damage")
      approachAbsorption += 1
    }
    if side == .invader, carriers.power > 0 {
      print("Carriers will deploy \(min(carriers.power, carriers.deployablePower)) corvettes")
      corvettes.power += min(carriers.power, carriers.deployablePower)
    }
  }


  func enterSalvoStep() {
    if corvettes.power > 0 && (technologies.contains(.shields) || technologies.contains(.shieldsV2)) {
      print("Shields will absorb 1 salvo damage")
      salvoAbsorption += 1
    }
    if side == .invader, technologies.contains(.autoDrones) {
      print("Autodrones will absorb 1 salvo damage")
      salvoAbsorption += 1
      if technologies.contains(.autoDronesV2) {
        print("Advanced Autodrones will absorb 1 more salvo damage")
        salvoAbsorption += 1
      }
    }
    if side == .defender && carriers.power > 0 {
      print("Carriers will absorb \(carriers.power) salvo damage")
      salvoAbsorption += carriers.power
    }
  }

  func sufferApproachDamage() {
    if approachAbsorption > 0 {
      approachAbsorption -= 1
      print("prevented approach damage")
      return
    }
    print("suffers damage")
    fleets.first(where: {$0.power > 0})?.damage()
  }

  func sufferSalvoDamage() {
    if salvoAbsorption > 0 {
      salvoAbsorption -= 1
      print("prevented salvo damage")
      return
    }
    print("suffers damage")
    fleets.first(where: {$0.power > 0})?.damage()
  }
}
