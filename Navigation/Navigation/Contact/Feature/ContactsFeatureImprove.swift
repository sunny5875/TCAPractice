//
//  ContactsFeature.swift
//  Navigation
//
//  Created by 현수빈 on 7/13/24.
//

import Foundation
import ComposableArchitecture


// MARK: - 기존 ContactsFeature와 차이점: Destination이라는 enum을 추가하여 다른 화면으로 갈 수 있는 흐름들을 따로 관리

extension ContactsFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case addContact(AddContactFeature)
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
    
}

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
        var contacts: IdentifiedArrayOf<Contact> = []
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case addButtonTapped
        case deleteButtonTapped(id: Contact.ID)
        case destination(PresentationAction<Destination.Action>)
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactFeature.State(
                        contact: Contact(id: UUID(), name: "")
                    )
                )
                return .none
                
            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none
                
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none
                
            case .destination:
                return .none
                
            case let .deleteButtonTapped(id: id):
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
