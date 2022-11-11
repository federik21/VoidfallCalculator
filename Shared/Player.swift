//
//  Player.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation

enum Technology {
  case shields, shieldsV2
}

class Player {
  var fleets: [Fleet]
  var technologies: [Technology] = []

  var hasCorvettes: Bool {
    for fleet in fleets {
      if fleet.power > 0, fleet is Corvette {
        return true
      }
    }
    return false
  }

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

  var advShieldsUsed: Bool = false

  func sufferApproachDamage() {
    if hasCorvettes && technologies.contains(.shieldsV2)  && !advShieldsUsed {
      advShieldsUsed = true
      print("prevented approach damage")
      return
    }
    print("suffers damage")

    fleets.first?.damage()
  }

  var shieldsUsed: Bool = false

  func sufferSalvoDamage() {
    if hasCorvettes && technologies.contains(.shields) || technologies.contains(.shieldsV2) && !shieldsUsed {
      shieldsUsed = true
      print("prevented salvo damage")
      return
    }
    print("suffers damage")
    fleets.first?.damage()
  }
}
