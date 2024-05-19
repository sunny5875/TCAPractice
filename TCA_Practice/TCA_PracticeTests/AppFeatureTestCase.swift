//
//  AppFeatureTestCase.swift
//  TCA_PracticeTests
//
//  Created by 현수빈 on 5/19/24.
//
import ComposableArchitecture
import XCTest


@testable import TCA_Practice


final class AppFeatureTests: XCTestCase {
    
    
    @MainActor
  func testIncrementInFirstTab() async {
    let store = TestStore(initialState: AppFeature.State()) {
      AppFeature()
    }
    
    await store.send(\.tab1.incrementButtonTapped) {
      $0.tab1.count = 1
    }
  }
}
