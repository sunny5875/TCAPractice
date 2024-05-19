//
//  TimerTestCase.swift
//  TCA_PracticeTests
//
//  Created by 현수빈 on 5/19/24.
//

import ComposableArchitecture
import XCTest

@testable import TCA_Practice


final class TimerTestCase: XCTestCase {
    
    // MARK: - Timer Test code
    @MainActor
    func testTimer() async {
        
        let store = TestStore(
            initialState: CounterFeature.State()
        )  {
            CounterFeature()
        }
        
        
        // 테스트가 계속해서 timer가 돌아가기에 fail 발생
        // 따라서 store.receive 함수를 통해서 타이머의 count가 증가함을 명시
        await store.receive(\.timerTick, timeout: .seconds(2)) { //timeout으로 testStore의 작업이 끝나는 것을 명시해줘야 정확히 teststore가 기다리지 않아 통과됨(Task.Sleep보다 명시적인 방법)
            $0.count = 1
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
    }
    
    // Dependencies를 이용하여 test하는 clock을 의존성 주입해서 테스트(좀 더 better!)
    @MainActor
    func testTimer2() async {
        
        let clock = TestClock()
        
        
        let store = TestStore(
            initialState: CounterFeature.State()
        )  {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        
        // test clock을 원하는 시간으로 timer 동작
        await clock.advance(by: .seconds(1))
        
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
}
