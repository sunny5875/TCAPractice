//
//  CounterFeature.swift
//  TCA_Practice
//
//  Created by 현수빈 on 5/14/24.
//
import ComposableArchitecture
import Foundation

@Reducer // reducer protocol을 구현하는 것을 도와주는 매크로
struct CounterFeature {
    @ObservableState // feature가 해야하는 state들을 정의, struct, tca에서의 @observable 같은 느낌
    struct State {
        var count = 0
    }
    
    // 사용자가 하는 action 지정
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    // 실질적으로 action에 따라 어떤 state로 변경되는지와 effect를 기술
    var body: some ReducerOf<Self> {
       Reduce { state, action in
         switch action {
         case .decrementButtonTapped:
           state.count -= 1
           return .none // none으 아무 영향이 없음을 의미
           
         case .incrementButtonTapped:
           state.count += 1
           return .none
         }
       }
     }
}
