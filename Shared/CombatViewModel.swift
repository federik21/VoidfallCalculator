//
//  CombatViewModel.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation

class CombatViewModel {
  var attacker: Player
  var defender: Player
  var sectorDefenses: Int
  init (attacker: Player,
        defender: Player,
        sectorDefenses: Int){
    self.attacker = attacker
    self.defender = defender
    self.sectorDefenses = sectorDefenses
  }

  func combat() {
    print("start Combat step")
    approachStep()
  }

  func approachStep() {
    print("start Approach step")
    attacker.enterApproachStep()
    defender.enterApproachStep()
    if attacker.destroyers.power > 0 && attacker.technologies.contains(.destroyersV2) {
      print("defender")
      defender.sufferApproachDamage()
    }
    while sectorDefenses > 0 {
      sectorDefenses -= 1
      print("attacker")
      attacker.sufferApproachDamage()
    }
    startSalvo()
  }

  func startSalvo(){
    print("Start salvo step")
    attacker.enterSalvoStep()
    defender.enterSalvoStep()

    salvoStep(additionalAttackerDamage: attacker.destroyers.power)
  }

  func salvoStep(additionalAttackerDamage: Int = 0) {
    print("salvo step")
    guard attacker.power > 0, defender.power > 0 else {
      print("no more fleet power on one side, combat is over")
      combatComplete()
      return
    }
    if attacker.initiative == defender.initiative {
      print("attacker")
      attacker.sufferSalvoDamage()
      print("defender")
      defender.sufferSalvoDamage(plus: additionalAttackerDamage)
    } else if attacker.initiative > defender.initiative {
      print("defender")

      defender.sufferSalvoDamage(plus: additionalAttackerDamage)
      if defender.power > 0 {
        print("then attacker ")
        attacker.sufferSalvoDamage()
      }
    } else if attacker.initiative < defender.initiative {
      print("attacker ")
      attacker.sufferSalvoDamage()
      if attacker.power > 0 {
        print("then defender")
        defender.sufferSalvoDamage(plus: additionalAttackerDamage)
      }
    }
    salvoStep()
  }

  func combatComplete() {
    print("final result")
    print("attacker \(attacker.power)")
    print("defender \(defender.power)")
  }
}
