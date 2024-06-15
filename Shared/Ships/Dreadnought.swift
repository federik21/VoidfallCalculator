//
//  Dreadnought.swift
//  VoidfallCombat
//
//  Created by federico piccirilli on 12/11/2022.
//

import Foundation

struct Dreadnought: Fleet {
  var power: Int

  init(power: Int? = 0) {
    self.power = power ?? 0
  }
  mutating func damage() {
    self.power -= 1
  }
}
