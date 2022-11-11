//
//  Ships.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation

class Corvette: Fleet {
  var power: Int
  init(power: Int) {
    self.power = power
  }
  func damage() {
    self.power -= 1
  }
}
