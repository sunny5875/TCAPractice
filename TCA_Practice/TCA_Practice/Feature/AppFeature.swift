//
//  AppFeature.swift
//  TCA_Practice
//
//  Created by 현수빈 on 5/19/24.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
    
  struct State: Equatable {
    var tab1 = CounterFeature.State()
    var tab2 = CounterFeature.State()
  }
    
  enum Action {
    case tab1(CounterFeature.Action)
    case tab2(CounterFeature.Action)
  }
    
    
  var body: some ReducerOf<Self> {
    // Scope 함수를 통해서 sub domain을 생성 가능
    Scope(state: \.tab1, action: \.tab1) {
      CounterFeature()
    }
    Scope(state: \.tab2, action: \.tab2) {
      CounterFeature()
    }
    Reduce { state, action in
      // Core logic of the app feature
      return .none
    }
  }
}
