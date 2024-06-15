//
//  Sentry.swift
//  VoidfallCombat
//
//  Created by federico piccirilli on 13/11/2022.
//

import Foundation

struct Sentry: Fleet {
  var power: Int
  init(power: Int? = 0) {
    self.power = power ?? 0
  }
  mutating func damage() {
    self.power -= 1
  }
}

