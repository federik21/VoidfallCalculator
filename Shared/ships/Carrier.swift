//
//  Carrier.swift
//  VoidfallCombat
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation

class Carrier: Fleet {
  var initiative: Int {
    return power
  }
  var deployablePower: Int
  var power: Int

  init(power: Int, deployablePower: Int) {
    self.power = power
    self.deployablePower = deployablePower
  }
  func damage() {
    self.power -= 1
  }

}
