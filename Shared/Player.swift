//
//  Player.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation

class Player {
  var fleets: [Fleet]

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

  init(fleets: [Fleet]) {
    self.fleets = fleets
  }

  func sufferDamage() {
    fleets.first?.damage()
  }
}
