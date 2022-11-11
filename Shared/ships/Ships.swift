//
//  Ships.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 11/11/2022.
//

import Foundation


class Corvette: Fleet {
  var initiative: Int {
    return power
  }
  var power: Int
  init(power: Int) {
    self.power = power
  }
  func damage() {
    self.power -= 1
  }
}

protocol Fleet {
  var power: Int {get set}
  var initiative: Int {get}
  func damage()
}
