//
//  CounterApp.swift
//  Counter
//
//  Created by Yongfeng on 12/16/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct GameApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                GameView(
                    store: Store(
                        initialState: GameState(),
                        reducer: gameReducer,
                        environment: GameEnvironment())
                )
            }
        }
    }
}
