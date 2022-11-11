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
    let attacker = Player(fleets: [Corvette(power: 3)])
    let defender = Player(fleets: [Corvette(power: 2)])
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 2)
    assert(defender.power == 0)
  }

  func testCombat2() {
    let attacker = Player(fleets: [Corvette(power: 3)])
    let defender = Player(fleets: [Corvette(power: 2)])
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 1)
    combat.combat()
    assert(attacker.power == 0)
    assert(defender.power == 0)
  }

  func testCombat3() {
    let attacker = Player(fleets: [Corvette(power: 3)])
    let defender = Player(fleets: [Corvette(power: 2)])
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 2)
    combat.combat()
    assert(attacker.power == 0)
    assert(defender.power == 2)
  }

  func testCombat4() {
    let attacker = Player(fleets: [Corvette(power: 3)])
    attacker.technologies = [.shields]
    let defender = Player(fleets: [Corvette(power: 3)])
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 0)
    combat.combat()
    assert(attacker.power == 2)
    assert(defender.power == 0)
  }

  func testCombat5() {
    let attacker = Player(fleets: [Corvette(power: 3)])
    attacker.technologies = [.shieldsV2]
    let defender = Player(fleets: [Corvette(power: 3)])
    let combat = CombatViewModel(attacker: attacker, defender: defender, sectorDefenses: 2)
    combat.combat()
    assert(attacker.power == 0)
    assert(defender.power == 0)
  }
}