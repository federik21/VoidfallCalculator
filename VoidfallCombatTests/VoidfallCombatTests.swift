//
//  VoidfallCombatTests.swift
//  VoidfallCombatTests
//
//  Created by federico piccirilli on 11/11/2022.
//

import XCTest

class VoidfallCombatTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }

  func testCombat() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.corvettes.power = 3
    defender.corvettes.power = 2
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 2)
    assert(defender.power == 0)
  }

  func testCombat2() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.corvettes.power = 3
    defender.corvettes.power = 2
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 1)
    combat.combat()
    assert(attacker.power == 0)
    assert(defender.power == 0)
  }

  func testCombat3() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.corvettes.power = 3
    defender.corvettes.power = 2
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 2)
    combat.combat()
    assert(attacker.power == 0)
    assert(defender.power == 2)
  }

  func testCombat4() {
    let attacker = Player(side: .invader)
    attacker.technologies = [.shields]
    let defender = Player(side: .defender)
    attacker.corvettes.power = 3
    defender.corvettes.power = 3
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 2)
    assert(defender.power == 0)
  }

  func testCombat5() {
    let attacker = Player(side: .invader)
    attacker.technologies = [.shieldsV2]
    let defender = Player(side: .defender)
    attacker.corvettes.power = 3
    defender.corvettes.power = 3
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 2)
    combat.combat()
    assert(attacker.power == 0)
    assert(defender.power == 0)
  }

  func testCombatCarrier() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.corvettes.power = 1
    attacker.carriers.power = 1
    attacker.carriers.deployablePower = 1
    defender.corvettes.power = 2
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 2)
    assert(defender.power == 0)
  }

  func testCombatCarrier2() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.corvettes.power = 3
    defender.carriers.power = 2
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 0)
    assert(defender.power == 2)
  }

  func testCombatCarrier3() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.corvettes.power = 3
    defender.carriers.power = 1
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 1)
    combat.combat()
    assert(attacker.power == 0)
    assert(defender.power == 0)
  }

  func testDestroyers() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.destroyers.power = 2
    defender.carriers.power = 1
    defender.corvettes.power = 2
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 1)
    assert(defender.power == 0)
  }

  func testDestroyers2() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.destroyers.power = 2
    defender.corvettes.power = 4
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 0)
    assert(defender.power == 1)
  }

  func testEnergyCells() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.destroyers.power = 2
    defender.corvettes.power = 1
    defender.technologies.append(.energyCells)
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 1)
    combat.combat()
    assert(attacker.power == 0)
    assert(defender.power == 1)
  }

  func testSentry() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.corvettes.power = 3
    defender.sentries.power = 2
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 1)
    assert(defender.power == 0)
  }

  func testTargeting() {
    let defender = Player(side: .defender)
    defender.corvettes.power = 1
    defender.destroyers.power = 1
    defender.sentries.power = 2
    defender.technologies.append(.targeting)
    assert(defender.initiative == 7)

    defender.corvettes.power = 0
    defender.destroyers.power = 0
//     Still has sentries
    assert(defender.initiative == 0)
  }
  func testTorpedoes() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.corvettes.power = 2
    attacker.technologies = [.torpedoes]
    defender.corvettes.power = 2
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 1)
    assert(defender.power == 0)
  }

  func testTorpedoesV2() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.corvettes.power = 4
    attacker.technologies = [.torpedoesV2]
    defender.corvettes.power = 6
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 1)
    assert(defender.power == 0)
  }

  func testACH() {
    let attacker = Player(side: .invader)
    let defender = Player(side: .defender)
    attacker.corvettes.power = 1
    attacker.dreadnoughts.power = 3
    attacker.technologies = [.torpedoesV2]
    defender.dreadnoughts.power = 1
    defender.corvettes.power = 2
    attacker.technologies = [.shields]

    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()

  }
}
