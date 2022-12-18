//
//  CounterTests.swift
//  CounterTests
//
//  Created by 柴勇峰 on 12/16/22.
//

import XCTest
@testable import Counter
import ComposableArchitecture

final class CounterTests: XCTestCase {
    
    var store: TestStore<Counter, CounterAction, Counter, CounterAction, CounterEnvironment>!

    override func setUpWithError() throws {
      store = TestStore(
        initialState: Counter(count: Int.random(in: -100...100)),
        reducer: counterReducer,
        environment: .test
      )
    }

    func testCounterIncrement() throws {
      store.send(.increment) { state in
        state.count += 1
      }
    }
    
    func testCounterDecrement() throws {
      store.send(.decrement) { state in
        state.count -= 1
      }
    }
    
    func testReset() throws {
      store.send(.reset) { state in
        state = Counter(count: 0, secret: 5, id: .dummy)
      }
    }
    
    func testSetCount() {
      store.send(.setCount("100")) { state in
        state.count = 100
      }
    }
    
    func testSliderSetCount() {
      store.send(.slidingCount(72.3)) { state in
        state.count = 72
      }
    }
}

extension UUID {
  static let dummy = UUID(uuidString: "ABABABAB-CDCD-EFEF-ABAB-CDCDCDCDCDCD")!
}

extension CounterEnvironment {
  static let test = CounterEnvironment(
    generateRandom: { _ in 5 },
    uuid: { .dummy }
  )
}
