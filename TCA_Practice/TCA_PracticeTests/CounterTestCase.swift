//
//  CounterTestCase.swift
//  TCA_PracticeTests
//
//  Created by 현수빈 on 5/19/24.
//

import ComposableArchitecture
import XCTest

@testable import TCA_Practice


final class CounterTestCase: XCTestCase {
    
    // MARK: - counter Test code
    
    // Store은 main thread에서 초기화해야 함.
    // 튜토리얼은 test class에 MainActor를 붙였지만 Swift6부터는 에러로 간주되므로 함수에 붙임
    @MainActor
    func testCounter() async {
        let store = TestStore(
            initialState: CounterFeature.State()
        ) {
            CounterFeature()
        } 
        
        // test store에서 closure로 해당 action이 일어나면 어떤 state가 바뀌는지 명시해야 테스트가 통과됨
        await store.send(.incrementButtonTapped) {
            $0.count = 1 // 여기서는 relative mutation보다는 absolute mutation을 작성하는 것이 더 용이
        }
        
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
}
