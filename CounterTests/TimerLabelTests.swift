//
//  TimerLabelTests.swift
//  CounterTests
//
//  Created by Yongfeng on 12/17/22.
//

import XCTest
import ComposableArchitecture
@testable import Counter

final class TimerLabelTests: XCTestCase {
    
    let scheduler = DispatchQueue.test

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testTimerUpdate() throws {
        let store = TestStore(
          initialState: TimerState(),
          reducer: timerReducer,
          environment: TimerEnvironment(
            date: { Date(timeIntervalSince1970: 100) },
            mainQueue: scheduler.eraseToAnyScheduler()
          )
        )
        
        store.send(.start) {
          $0.started = Date(timeIntervalSince1970: 100)
        }
        
        // 1
        scheduler.advance(by: .milliseconds(35))
        // 2
        store.receive(.timeUpdated) {
          $0.duration = 0.01
        }
        store.receive(.timeUpdated) {
          $0.duration = 0.02
        }
        store.receive(.timeUpdated) {
          $0.duration = 0.03
        }
        // 3
        store.send(.stop)
    }
}
