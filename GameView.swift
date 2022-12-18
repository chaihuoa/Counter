//
//  GameView.swift
//  Counter
//
//  Created by Yongfeng on 12/17/22.
//

import SwiftUI
import ComposableArchitecture

struct GameState: Equatable {
    var counter: CounterState = .init()
    var timer: TimerState = .init()
}

enum GameAction {
    case counter(CounterAction)
    case timer(TimerAction)
}

struct GameEnvironment { }

let gameReducer = AnyReducer<GameState, GameAction, GameEnvironment>.combine(
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
        WithViewStore(store.stateless) { viewStore in
            VStack {
                TimerLabelView(store: store.scope(state: \.timer, action: GameAction.timer))
                CounterView(store: store.scope(state: \.counter, action: GameAction.counter))
            }.onAppear {
                viewStore.send(.timer(.start))
            }
        }
    }
}
