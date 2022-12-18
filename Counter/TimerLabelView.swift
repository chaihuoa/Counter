//
//  TimerLabelView.swift
//  Counter
//
//  Created by Yongfeng on 12/17/22.
//

import SwiftUI
import ComposableArchitecture

// 1. Define state
struct TimerState: Equatable {
    var started: Date? = nil
    var duration: TimeInterval = 0
}

// 2. Action
enum TimerAction {
    case start
    case stop
    case timeUpdated
}

struct TimerEnvironment {
    // Effect 1
    var date: () -> Date
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static var live: TimerEnvironment {
        .init(date: Date.init, mainQueue: .main)
    }
}

// 3. Reducer
let timerReducer = AnyReducer<TimerState, TimerAction, TimerEnvironment> {
    state, action, environment in
    
    // Effect 2
    struct TimerId: Hashable {}
    
    switch action {
    case .start:
        if state.started == nil {
            state.started = environment.date()
        }
        // Effect 3
        return Effect.timer(id: TimerId(), every: .milliseconds(10), on: environment.mainQueue).map { timer -> TimerAction in
            return TimerAction.timeUpdated
        }
    case .timeUpdated:
        state.duration += 0.01
        return .none
    case .stop:
        return .cancel(id: TimerId())
    }
}

// 4. View
struct TimerLabelView: View {
    let store: Store<TimerState, TimerAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Label(
                    viewStore.started == nil ? "-" : "\(viewStore.started!.formatted(date: .omitted, time: .standard))",
                    systemImage: "clock"
                )
                Label(
                    "\(viewStore.duration, format: .number)s",
                    systemImage: "timer"
                )
            }
        }
    }
}

struct TimerLabelView_Previews: PreviewProvider {
  static let store = Store(initialState: .init(), reducer: timerReducer, environment: .live)
  static var previews: some View {
    VStack {
      WithViewStore(store) { viewStore in
        VStack {
          TimerLabelView(store: store)
          HStack {
            Button("Start") { viewStore.send(.start) }
            Button("Stop") { viewStore.send(.stop) }
          }.padding()
        }
      }
    }
  }
}
