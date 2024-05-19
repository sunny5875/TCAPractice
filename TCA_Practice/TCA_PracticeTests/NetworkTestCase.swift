//
//  NetworkTestCase.swift
//  TCA_PracticeTests
//
//  Created by 현수빈 on 5/19/24.
//

import XCTest
import ComposableArchitecture

@testable import TCA_Practice


final class NetworkTestCase: XCTestCase {
    
    @MainActor
    func testNumberFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is a good number" }
        }
        
        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.factResponse) {
             $0.isLoading = false
             $0.fact = "0 is a good number."
           }
    }
    
}
