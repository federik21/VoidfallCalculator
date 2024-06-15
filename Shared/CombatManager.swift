//
//  CombatManager.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 14/06/2024.
//

import Foundation

class CombatManager {

  @Published var logLine: String = "" {
    didSet {
      print(logLine)
    }
  }

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
    logLine = "start Combat step"
    logForces()
    approachStep()
  }

  func logForces() {
    logLine = "Attacker"
    if attacker.hasCorvettes {
      logLine = "corvettes \(attacker.corvettes.power)"
    }    
    if attacker.hasDestroyers {
      logLine = "destroyers \(attacker.destroyers.power)"
    }    
    if attacker.hasDreadnought {
      logLine = "dreadnoughts \(attacker.dreadnoughts.power)"
    }    
    if attacker.hasSentries {
      logLine = "sentries\(attacker.sentries.power)"
    }    
    if attacker.hasCarrier {
      logLine = "carriers \(attacker.carriers.power), dp. \(attacker.carriers.deployablePower)"
    }
    logLine = "Defender"
    if defender.hasCorvettes {
      logLine = "corvettes \(defender.corvettes.power)"
    }    
    if defender.hasDestroyers {
      logLine = "destroyers \(defender.destroyers.power)"
    }    
    if defender.hasDreadnought {
      logLine = "dreadnoughts \(defender.dreadnoughts.power)"
    }    
    if defender.hasSentries {
      logLine = "sentries\(defender.sentries.power)"
    }    
    if defender.hasCarrier {
      logLine = "carriers \(defender.carriers.power)"
    }
    if sectorDefenses > 0 {
      logLine = "sectorDefenses \(sectorDefenses)"
    }

  }

  func approachStep() {
    logLine = "start Approach step"
    enterApproachStep(player: attacker)
    enterApproachStep(player: defender)
    var damageForAttacker = 0
    var damageForDefender = 0
    if attacker.hasDestroyers && attacker.technologies.contains(.destroyersV2) {
      logLine = "Attacker Dealing \(attacker.destroyers.power) damage with Destroyers v2 "
      damageForDefender += attacker.destroyers.power
    }
    if attacker.technologies.contains(.deepSpaceMissiles) {
      damageForDefender += 1
    }

    damageForAttacker += sectorDefenses + defender.sentries.power

    if damageForDefender > 0 {
      inflict(on: defender, newTotal: damageForDefender, step: .approach)
    }
    if damageForAttacker > 0 {
      if defender.technologies.contains(.energyCells) {
        logLine = "Defender triggers energycells"
        damageForAttacker += 1
      }
      logLine = "Defender deals \(damageForAttacker)"
      inflict(on: attacker, newTotal: damageForAttacker, step: .approach)
    }
    startSalvo()
    logLine = "End of Approach"
  }

  func startSalvo(){
    logLine = "Entering salvo step"
    enterSalvoStep(player: attacker)
    enterSalvoStep(player: defender)
    salvoStep(first: true)
  }

  func salvoStep(first: Bool = false) {
    logLine = "SALVO STEP"
    let step = first ? CombatStep.firstSalvo : CombatStep.salvo
    guard attacker.power > 0, defender.power > 0 else {
      logLine = "No more fleet power on one side, combat is over"
      combatComplete()
      return
    }
    
    if attacker.initiative == defender.initiative {
      let totalDamageForDef = calculateSalvoDamageOutput(on: defender, step: step)
      let totalDamageForAtt = calculateSalvoDamageOutput(on: attacker, step: step)
      logLine = "At the same time, Attacker deals \(totalDamageForDef) and Defender deals \(totalDamageForAtt)"
      inflict(on: attacker, newTotal: totalDamageForAtt, step: step)
      inflict(on: defender, newTotal: totalDamageForDef, step: step)

    } else if attacker.initiative > defender.initiative || (attacker.technologies.contains(.targetingV2) && !defender.technologies.contains(.targetingV2)){
      logLine = "Attacker goes first, 1 damage"
      if attacker.initiative > 0 {
        calculateAndInflictDamage(on: defender, step: step)
      }
      if defender.power > 0 && defender.initiative > 0{
        logLine = "then Defender 1 damage"
        calculateAndInflictDamage(on: attacker, step: step)
      }
    } else if attacker.initiative < defender.initiative || (defender.technologies.contains(.targetingV2) &&
                !attacker.technologies.contains(.targetingV2)) {
      logLine = "Defender goes first 1 damage"
      if defender.initiative > 0{
        calculateAndInflictDamage(on: attacker, step: step)
      }
      if attacker.power > 0 && attacker.initiative > 0 {
        logLine = "then Attacker 1 damage"
        calculateAndInflictDamage(on: defender, step: step)
      }
    }
    // REDO
    salvoStep()
  }

  func combatComplete() {
    logLine = "final result:"
    logLine = "attacker \(attacker.power)"
    logLine = "defender \(defender.power)"
  }

  func calculateAndInflictDamage(on player: Player, step: CombatStep){
    let damage = calculateSalvoDamageOutput(on: player, step: step)
    inflict(on: player, newTotal: damage, step: .salvo)
  }

  func calculateSalvoDamageOutput(on player: Player, step: CombatStep) -> Int {
    var newTotal = 1
    if player.side == .defender {
      if step == .firstSalvo {
        if (attacker.technologies.contains(.torpedoes) || attacker.technologies.contains(.torpedoesV2))  && attacker.hasCorvettes {
          logLine = "plus 1 damage"
          newTotal += 1
        }
        newTotal += attacker.destroyers.power
      } else if step == .salvo && attacker.technologies.contains(.torpedoesV2) && attacker.corvettes.power > 0 {
        logLine = "plus 1 damage"
        newTotal += 1
      }
    }
    return newTotal
  }

  func inflict(on player: Player, newTotal: Int, step: CombatStep) {
    for _ in 1...newTotal {
      if (step == .approach)
          && player.approachAbsorption > 0 {
        player.approachAbsorption -= 1
        logLine = "\(player.side.rawValue) absorbed 1 damage"
        continue
      }
      if (step == .firstSalvo || step == .salvo)
          && player.salvoAbsorption > 0 {
        player.salvoAbsorption -= 1
        logLine = "\(player.side.rawValue) absorbed 1 damage"
        continue
      }
      let fleets = player.getHealtyFleetsTypes()
      // TODO: player should choose what power fleet to lose, if they has more
      if let selectedFleetType = fleets.first {
        player.sufferDamage(on: selectedFleetType)
      }
    }
  }

  func enterApproachStep(player: Player) {
    if player.hasCorvettes && player.technologies.contains(.shieldsV2) {
      logLine = "Improved shields will absorb 1 approach damage"
      player.approachAbsorption += 1
    }
    if player.side == .invader, player.technologies.contains(.autoDrones), player.technologies.contains(.autoDronesV2) {
      logLine = "Autonomous drones will absorb 1 approach damage"
      player.approachAbsorption += 1
    }
    if player.side == .invader, player.hasCarrier {
      logLine = "Carriers will deploy \(min(player.carriers.power, player.carriers.deployablePower)) corvettes"
      // Power is capped by carriers fleet power
      player.corvettes.power += min(player.carriers.power, player.carriers.deployablePower)
    }
    if player.side == .invader {
      player.approachAbsorption += player.dreadnoughts.power
    }
  }

  func enterSalvoStep(player: Player) {
    if player.hasCorvettes && ((player.technologies.contains(.shields) || player.technologies.contains(.shieldsV2))) {
      logLine = "Shields will absorb 1 salvo damage"
      player.salvoAbsorption += 1
    }
    if player.side == .invader, player.technologies.contains(.autoDrones) {
      logLine = "Autodrones will absorb 1 salvo damage"
      player.salvoAbsorption += 1
      if player.technologies.contains(.autoDronesV2) {
        logLine = "Advanced Autodrones will absorb 1 more salvo damage"
        player.salvoAbsorption += 1
      }
    }
    if player.side == .defender && player.hasCarrier {
      logLine = "Carriers will absorb \(player.carriers.power) salvo damage"
      player.salvoAbsorption += player.carriers.power
    }
    if player.side == .defender && player.hasDreadnought {
      logLine = "Dreadnoughts will absorb \(player.dreadnoughts.power) salvo damage"
      player.salvoAbsorption += player.dreadnoughts.power
    }
  }
}
