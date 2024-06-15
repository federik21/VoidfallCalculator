//
//  Carrier.swift
//  VoidfallCombat
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation

struct Carrier: Fleet {
  var deployablePower: Int
  var power: Int

  init(power: Int, deployablePower: Int) {
    self.power = power
    self.deployablePower = deployablePower
  }
  mutating func damage() {
    self.power -= 1
  }
}
