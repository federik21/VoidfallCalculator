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
    approach()
  }

  func approach() {
  print("start Approach step")
   while sectorDefenses > 0 {
     sectorDefenses -= 1
      print("attacker suffers damage")
      attacker.sufferDamage()
    }
    repeatSalvo()
  }

  func repeatSalvo() {
    print("salvo step")
    guard attacker.power > 0, defender.power > 0 else {
      print("no more fleet power on one side, combat is over")
      combatComplete()
      return
    }
    if attacker.initiative == defender.initiative {
      print("attacker suffers damage")
      attacker.sufferDamage()
      print("defender suffers damage")
      defender.sufferDamage()
    } else if attacker.initiative > defender.initiative {
      print("defender suffers damage")

      defender.sufferDamage()
      if defender.power > 0 {
        print("then attacker suffers damage")
        attacker.sufferDamage()
      }
    } else if attacker.initiative < defender.initiative {
      print("attacker suffers damage")
      attacker.sufferDamage()
      if attacker.power > 0 {
        print("then defender suffers damage")
        defender.sufferDamage()
      }
    }
    repeatSalvo()
  }

  func combatComplete() {
    print("final result")
    print("attacker \(attacker.power)")
    print("defender \(defender.power)")

  }
}
