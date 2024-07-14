//
//  ContactFeatureText.swift
//  ContactFeatureText
//
//  Created by 현수빈 on 7/14/24.
//

import XCTest
import ComposableArchitecture

@testable import Navigation

@MainActor
final class ContactFeatureText: XCTestCase {
    
    func testAddFlow() async {
        
        // 0. test store 설정 + depedency 설정
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        // 1. 추가 버튼 클릭
        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                AddContactFeature.State(
                    contact: Contact(id: UUID(0), name: "")
                )
            )
        }
        
        // 2. 이름 작성
        let name = "Sunny"
        await store.send(\.destination.addContact.setName, name) {
            $0.destination?.addContact?.contact.name = name
        }
        
        // 3. save 버튼 클릭
        await store.send(\.destination.addContact.saveButtonTapped)
        
        await store.receive(
            \.destination.addContact.delegate.saveContact,
             Contact(id: UUID(0), name: name)
        ) {
            $0.contacts = [
                Contact(id: UUID(0), name: name )
            ]
        }
        
        await store.receive(\.destination.dismiss) {
            $0.destination = .none
        }
    }
}
