//
//  Ships.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation

struct Corvette: Fleet {
  var power: Int
  init(power: Int) {
    self.power = power
  }
  mutating func damage() {
    self.power -= 1
  }
}
