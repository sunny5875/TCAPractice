//
//  NumberFactClient.swift
//  TCA_Practice
//
//  Created by 현수빈 on 5/19/24.
//
import ComposableArchitecture
import Foundation


// protocol로 abstracting dependency interface를 빼는 방법과 동일한 다른 방법
struct NumberFactClient {
  var fetch: (Int) async throws -> String
}


extension NumberFactClient: DependencyKey {
  static let liveValue = Self(
    fetch: { number in
      let (data, _) = try await URLSession.shared
        .data(from: URL(string: "http://numbersapi.com/\(number)")!)
      return String(decoding: data, as: UTF8.self)
    }
  )
}

extension DependencyValues {
  var numberFact: NumberFactClient {
    get { self[NumberFactClient.self] }
    set { self[NumberFactClient.self] = newValue }
  }
}
