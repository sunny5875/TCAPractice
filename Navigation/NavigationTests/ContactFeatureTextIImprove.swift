//
//  ContactFeatureTextIImprove.swift
//  NavigationTests
//
//  Created by 현수빈 on 7/14/24.
//

import XCTest
import ComposableArchitecture

@testable import Navigation

@MainActor

final class ContactFeatureTextIImprove: XCTestCase {

    func testAddFlow_NonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off // 모든 효과를 테스하지 않고 테스트하는 방법
        
        await store.send(.addButtonTapped)
        await store.send(\.destination.addContact.setName, "Sunny")
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.skipReceivedActions() // effect로 부터 받은 action들이 있는 큐를 clear
        store.assert {
            $0.contacts = [
                Contact(id: UUID(0), name: "Sunny")
            ]
            $0.destination = nil
        }
    }

}
