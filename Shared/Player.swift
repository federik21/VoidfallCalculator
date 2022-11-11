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
  case attacker, defender
}

class Player {
  var fleets: [Fleet]
  var technologies: [Technology] = []
  var side: Side

  var hasCorvettes: Bool {
    for fleet in fleets {
      if fleet.power > 0, fleet is Corvette {
        return true
      }
    }
    return false
  }

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

  init(fleets: [Fleet], side: Side) {
    self.fleets = fleets
    self.side = side
  }

  var advShieldsUsed: Bool = false

  func enterApproachStep() {
    if hasCorvettes && technologies.contains(.shieldsV2) {
      approachAbsorption += 1
    }
    if side == .attacker, technologies.contains(.autoDrones), technologies.contains(.autoDronesV2) {
      approachAbsorption += 1
    }
  }

  func sufferApproachDamage() {
    if approachAbsorption > 0 {
      approachAbsorption -= 1
      print("prevented approach damage")
      return
    }
    print("suffers damage")

    fleets.first?.damage()
  }

  func enterSalvoStep(){
    if hasCorvettes && (technologies.contains(.shields) || technologies.contains(.shieldsV2)) {
      salvoAbsorption += 1
    }
    if side == .attacker, technologies.contains(.autoDrones) {
      approachAbsorption += 1
      if technologies.contains(.autoDronesV2) {
        approachAbsorption += 1
      }
    }
  }

  func sufferSalvoDamage() {
    if salvoAbsorption > 0 {
      salvoAbsorption -= 1
      print("prevented salvo damage")
      return
    }
    print("suffers damage")
    fleets.first?.damage()
  }
}
