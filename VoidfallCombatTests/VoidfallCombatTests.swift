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
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.corvettes.power = 3
    combat.defender.corvettes.power = 2
    combat.combat()
    assert(combat.attacker.power == 2)
    assert(combat.defender.power == 0)
  }

  func testCombat2() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.corvettes.power = 3
    combat.defender.corvettes.power = 2
    combat.sectorDefenses = 1
    combat.combat()
    assert(combat.attacker.power == 0)
    assert(combat.defender.power == 0)
  }

  func testCombat3() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.corvettes.power = 3
    combat.defender.corvettes.power = 2
    combat.sectorDefenses = 2
    combat.combat()
    assert(combat.attacker.power == 0)
    assert(combat.defender.power == 2)
  }


  func testCombat4() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    _ = tm.addTechnology(.shields, for: combat.attacker)
    combat.attacker.corvettes.power = 3
    combat.defender.corvettes.power = 3
    combat.combat()
    assert(combat.attacker.power == 2)
    assert(combat.defender.power == 0)
  }

  func testCombat5() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    _ = tm.addTechnology(.shieldsV2, for: combat.attacker)
    combat.attacker.corvettes.power = 3
    combat.defender.corvettes.power = 3
    combat.sectorDefenses = 2
    combat.combat()
    assert(combat.attacker.power == 0)
    assert(combat.defender.power == 0)
  }

  func testCombatCarrier() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.corvettes.power = 1
    combat.attacker.carriers.power = 1
    combat.attacker.carriers.deployablePower = 1
    combat.defender.corvettes.power = 2
    combat.combat()
    assert(combat.attacker.power == 2)
    assert(combat.defender.power == 0)
  }

  func testCombatCarrier2() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.corvettes.power = 3
    combat.defender.carriers.power = 2
    combat.combat()
    assert(combat.attacker.power == 0)
    assert(combat.defender.power == 2)
  }

  func testCombatCarrier3() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.corvettes.power = 3
    combat.defender.carriers.power = 1
    combat.sectorDefenses = 1
    combat.combat()
    assert(combat.attacker.power == 0)
    assert(combat.defender.power == 0)
  }

  func testDestroyers() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.destroyers.power = 2
    combat.defender.carriers.power = 1
    combat.defender.corvettes.power = 2
    combat.combat()
    assert(combat.attacker.power == 1)
    assert(combat.defender.power == 0)
  }

  func testDestroyers2() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.destroyers.power = 2
    combat.defender.corvettes.power = 4
    combat.combat()
    assert(combat.attacker.power == 0)
    assert(combat.defender.power == 1)
  }

  func testEnergyCells() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.destroyers.power = 2
    combat.defender.corvettes.power = 1
    _ = tm.addTechnology(.energyCells, for: combat.defender)
    combat.sectorDefenses = 1
    combat.combat()
    assert(combat.attacker.power == 0)
    assert(combat.defender.power == 1)
  }

  func testSentry() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.corvettes.power = 3
    combat.defender.sentries.power = 2
    combat.combat()
    assert(combat.attacker.power == 1)
    assert(combat.defender.power == 0)
  }

  func testTargeting() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.defender.corvettes.power = 2
    _ = tm.addTechnology(.targeting, for: combat.defender)
    assert(combat.defender.initiative == 7)
    combat.defender.corvettes.power = 0
    assert(combat.defender.initiative == 0)
  }

  func testTorpedoes() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.corvettes.power = 2
    _ = tm.addTechnology(.torpedoes, for: combat.attacker)
    combat.defender.corvettes.power = 2
    combat.combat()
    assert(combat.attacker.power == 1)
    assert(combat.defender.power == 0)
  }

  func testTorpedoesV2() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.corvettes.power = 4
    _ = tm.addTechnology(.torpedoesV2, for: combat.attacker)
    combat.defender.corvettes.power = 6
    combat.combat()
    assert(combat.attacker.power == 1)
    assert(combat.defender.power == 0)
  }

  func testACH() {
    let tm = TechnologyManager()
    let combat = CombatViewModel(technologyManager: tm)
    combat.attacker.corvettes.power = 1
    combat.attacker.dreadnoughts.power = 3
    _ = tm.addTechnology(.torpedoesV2, for: combat.attacker)
    _ = tm.addTechnology(.shields, for: combat.attacker)
    combat.defender.dreadnoughts.power = 1
    combat.defender.corvettes.power = 2
    combat.combat()

    assert(combat.attacker.power == 4)
    assert(combat.defender.power == 0)
  }
}
