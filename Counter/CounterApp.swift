//
//  CounterApp.swift
//  Counter
//
//  Created by Yongfeng on 12/16/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct CounterApp: App {
  var body: some Scene {
    WindowGroup {
      CounterView(
        store: Store(
          initialState: Counter(),
          reducer: counterReducer,
          environment: .live)
      )
    }
  }
}
