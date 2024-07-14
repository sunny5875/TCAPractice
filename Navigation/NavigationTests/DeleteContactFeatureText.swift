//
//  DeleteContactFeatureText.swift
//  NavigationTests
//
//  Created by 현수빈 on 7/14/24.
//

import XCTest
import ComposableArchitecture

@testable import Navigation

@MainActor
final class DeleteContactFeatureText: XCTestCase {

    func testDeleteContact() async {
        
        let store = TestStore(
            initialState: ContactsFeature.State(
                contacts: [
                    Contact(id: UUID(0), name: "Sunny"),
                    Contact(id: UUID(1), name: "Sunny2")
                ]
            )
        ) {
            ContactsFeature()
        }
        
        
        let deleteId = UUID(1)
        await store.send(.deleteButtonTapped(id: deleteId)) {
            $0.destination = .alert(.deleteConfirmation(id: deleteId))
        }
        
        await store.send(.destination(.presented(.alert(.confirmDeletion(id: UUID(1)))))) {
             $0.contacts.remove(id: deleteId)
             $0.destination = nil
           }
    }

}
