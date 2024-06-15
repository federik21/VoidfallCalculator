//
//  CombatManager.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 14/06/2024.
//

import Foundation

class CombatManager {

  enum CombatStep {
    case approach, firstSalvo, salvo
  }

  var sectorDefenses: Int = 0

  var attacker: Player
  var defender: Player

  init(sectorDefenses: Int, attacker: Player, defender: Player) {
    self.sectorDefenses = sectorDefenses
    self.attacker = attacker
    self.defender = defender
  }

  func combat() {
    print("start Combat step")
    approachStep()
  }

  func approachStep() {
    print("start Approach step")
    enterApproachStep(player: attacker)
    enterApproachStep(player: defender)
    var damageForAttacker = 0
    var damageForDefender = 0
    if attacker.destroyers.power > 0 && attacker.technologies.contains(.destroyersV2) {
      damageForDefender += 1
    }
    if attacker.technologies.contains(.deepSpaceMissiles) {
      damageForDefender += 1
    }

    damageForAttacker += sectorDefenses + defender.sentries.power

    if damageForDefender > 0 {
      print("defender")
      inflictDamage(on: defender, total: damageForDefender, step: .approach)
    }
    if damageForAttacker > 0 {
      if defender.technologies.contains(.energyCells) {
        damageForAttacker += 1
      }
      print("attacker")
      inflictDamage(on: attacker, total: damageForAttacker, step: .approach)
    }
    startSalvo()
    print("End of Approach")
  }

  func startSalvo(){
    print("Entering salvo step")
    enterSalvoStep(player: attacker)
    enterSalvoStep(player: defender)
    salvoStep(first: true)
  }

  func salvoStep(first: Bool = false) {
    print("salvo step")
    let step = first ? CombatStep.firstSalvo : CombatStep.salvo
    guard attacker.power > 0, defender.power > 0 else {
      print("no more fleet power on one side, combat is over")
      combatComplete()
      return
    }
    if attacker.initiative == defender.initiative {
      print("Same time, defender")
      inflictDamage(on: defender, step: step)
      print("attacker")
      inflictDamage(on: attacker, step: step)
    } else if attacker.initiative > defender.initiative {
      print("defender")
      inflictDamage(on: defender, step: step)
      if defender.power > 0 {
        print("then attacker ")
        inflictDamage(on: attacker, step: step)
      }
    } else if attacker.initiative < defender.initiative {
      print("attacker ")
      inflictDamage(on: attacker, step: step)
      if attacker.power > 0 {
        print("then defender")
        inflictDamage(on: defender, step: step)
      }
    }
    salvoStep(first: false)
  }

  func combatComplete() {
    print("final result")
    print("attacker \(attacker.power)")
    print("defender \(defender.power)")
  }

  func inflictDamage(on player: Player, total: Int = 1, step: CombatStep) {
    var newTotal = total
    if player.side == .defender {
      if step == .firstSalvo {
        if (attacker.technologies.contains(.torpedoes) || attacker.technologies.contains(.torpedoesV2))  && attacker.corvettes.power > 0 {
          newTotal += 1
        }
        newTotal += attacker.destroyers.power
      } else if step == .salvo && attacker.technologies.contains(.torpedoesV2) && attacker.corvettes.power > 0 {
        newTotal += 1
      }
    }

    for _ in 1...newTotal {
      if (step == .approach)
          && player.approachAbsorption > 0 {
        player.approachAbsorption -= 1
        continue
      }
      if (step == .firstSalvo || step == .salvo)
          && player.salvoAbsorption > 0 {
        player.salvoAbsorption -= 1
        continue
      }
      let fleets = player.getHealtyFleetsTypes()
      // TODO: player should choose what power fleet to lose, if they has more
      player.sufferDamage(on: fleets.first!)
    }
  }

  func enterApproachStep(player: Player) {
    if player.hasCorvettes && player.technologies.contains(.shieldsV2) {
      print("Improved shields will absorb 1 approach damage")
      player.approachAbsorption += 1
    }
    if player.side == .invader, player.technologies.contains(.autoDrones), player.technologies.contains(.autoDronesV2) {
      print("Autonomous drones will absorb 1 approach damage")
      player.approachAbsorption += 1
    }
    if player.side == .invader, player.hasCarrier {
      print("Carriers will deploy \(min(player.carriers.power, player.carriers.deployablePower)) corvettes")
      // Power is capped by carriers fleet power
      player.corvettes.power += min(player.carriers.power, player.carriers.deployablePower)
    }
    if player.side == .invader {
      player.approachAbsorption += player.dreadnoughts.power
    }
  }

  func enterSalvoStep(player: Player) {
    if player.hasCorvettes && ((player.technologies.contains(.shields) || player.technologies.contains(.shieldsV2))) {
      print("Shields will absorb 1 salvo damage")
      player.salvoAbsorption += 1
    }
    if player.side == .invader, player.technologies.contains(.autoDrones) {
      print("Autodrones will absorb 1 salvo damage")
      player.salvoAbsorption += 1
      if player.technologies.contains(.autoDronesV2) {
        print("Advanced Autodrones will absorb 1 more salvo damage")
        player.salvoAbsorption += 1
      }
    }
    if player.side == .defender && player.hasCarrier {
      print("Carriers will absorb \(player.carriers.power) salvo damage")
      player.salvoAbsorption += player.carriers.power
    }
    if player.side == .defender && player.hasDreadnought {
      print("Dreadnoughts will absorb \(player.dreadnoughts.power) salvo damage")
      player.salvoAbsorption += player.dreadnoughts.power
    }
  }
}
