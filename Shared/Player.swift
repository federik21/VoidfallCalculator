//
//  Player.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation

enum Technology {
  case shields, shieldsV2, autoDrones, autoDronesV2, destroyersV2,
       deepSpaceMissiles, deepSpaceMissilesV2oneSY, deepSpaceMissilesV2twoSY, energyCells
}

enum Side {
  case invader, defender
}

enum FleetTypes {
  case corvette, carrier, destroyer, dreadnought
}

class Player {
  var corvettes: Corvette = Corvette(power: 0)
  var carriers: Carrier = Carrier(power: 0, deployablePower: 0)
  var destroyers: Destroyer = Destroyer()
  var dreadnoughts: Dreadnought = Dreadnought()

  var fleets: [Fleet] {
    return [corvettes, carriers, destroyers, dreadnoughts]
  }

  // Technologies that would be used by the attacker
  var technologies: [Technology] = []
  var side: Side

  var approachAbsorption: Int = 0
  var salvoAbsorption: Int = 0

  var initiative: Int {
    var initiative = 0
    for fleet in fleets {
      initiative += fleet.power
      if (fleet is Destroyer || fleet is Dreadnought) && fleet.power > 0 {
        initiative += 1
      }
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
    if side == .invader {
      self.approachAbsorption += dreadnoughts.power
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
    if side == .defender && dreadnoughts.power > 0 {
      print("Dreadnoughts will absorb \(dreadnoughts.power) salvo damage")
      salvoAbsorption += dreadnoughts.power
    }
  }

  func sufferApproachDamage(total: Int) {
    for _ in 1...total {
      if approachAbsorption > 0 {
        approachAbsorption -= 1
        print("prevented approach damage")
      } else {
        print("suffers damage")
        fleets.first(where: {$0.power > 0})?.damage()
      }
    }
  }

  func sufferSalvoDamage(plus additionalDamage: Int = 0) {
    for _ in 1...(1 + additionalDamage) {
      if salvoAbsorption > 0 {
        salvoAbsorption -= 1
        print("prevented salvo damage")
      } else {
        print("suffers damage")
        // Remove the first ship for the sake of simplicity
        fleets.first(where: {$0.power > 0})?.damage()
      }
    }
  }
}
