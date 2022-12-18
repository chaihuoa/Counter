//
//  GameView.swift
//  Counter
//
//  Created by Yongfeng on 12/17/22.
//

import SwiftUI
import ComposableArchitecture

struct GameResult: Equatable, Identifiable {
    let counter: CounterState
    let timeSpent: TimeInterval

    var correct: Bool { counter.secret == counter.count }
    var id: UUID { counter.id }
}

struct GameState: Equatable {
    var counter: CounterState = .init()
    var timer: TimerState = .init()
    
    var results = IdentifiedArrayOf<GameResult>()
    var lastTimestamp = 0.0
}

enum GameAction {
    case counter(CounterAction)
    case timer(TimerAction)
}

struct GameEnvironment { }

let gameReducer = AnyReducer<GameState, GameAction, GameEnvironment>.combine(.init { state, action, environment in
    switch action {
    case .counter(.reset):
        let result = GameResult(
            counter: state.counter,
            timeSpent: state.timer.duration - state.lastTimestamp)
        state.results.append(result)
        state.lastTimestamp = state.timer.duration
        return .none
    default:
        return .none
    }
    },
    counterReducer.pullback(
        state: \.counter,
        action: /GameAction.counter,
        environment: { _ in .live }
    ),
    timerReducer.pullback(
        state: \.timer,
        action: /GameAction.timer,
        environment: { _ in .live }
    )
)

struct GameView: View {
    let store: Store<GameState, GameAction>
    var body: some View {
        WithViewStore(store.scope(state: \.results)) { viewStore in
            VStack {
                resultLabel(viewStore.state.elements)
                Divider()
                TimerLabelView(store: store.scope(state: \.timer, action: GameAction.timer))
                CounterView(store: store.scope(state: \.counter, action: GameAction.counter))
            }.onAppear {
                viewStore.send(.timer(.start))
            }
        }
    }
    func resultLabel(_ results: [GameResult]) -> some View {
        Text("Result: \(results.filter(\.correct).count)/\(results.count) correct")
    }
}
