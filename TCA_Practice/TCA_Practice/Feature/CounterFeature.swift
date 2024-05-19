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
    struct State: Equatable { // equatable을 준수해야하는 이유는 testStore만들 때 필요하기 때문
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    // 사용자가 하는 action 지정
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factResponse(String) // network로 보낼 때 state을 바꿀 수 없어(sendable closure를 위함) 바꾸는 action 추가
        case toggleTimerButtonTapped
        case timerTick
    }
    
    // effect cancellation, 타이머 중간에 멈추고 싶은 경우 cancel해주는 방법
    enum CancelID { case timer }
    
    // test 작성 시 clock dependency를 관리하기 위한 변수
    @Dependency(\.continuousClock) var clock
    
    // network depedency를 관리하기 위한 변수
    @Dependency(\.numberFact) var numberFact
    
    // 실질적으로 action에 따라 어떤 state로 변경되는지와 effect를 기술
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none // none으 아무 영향이 없음을 의미
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
//                    let (data, _) = try await URLSession.shared
//                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
//                    let fact = String(decoding: data, as: UTF8.self)
//                    await send(.factResponse(fact))
                    try await send(.factResponse(self.numberFact.fetch(count)))
                }
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer) // 여기서 중간에 멈출 cancel id 지정
                } else {
                    return .cancel(id: CancelID.timer) // 여기서 실질적으로 stop
                }
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
            }
        }
    }
}
