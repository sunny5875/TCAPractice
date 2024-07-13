//
//  ContactsFeature.swift
//  Navigation
//
//  Created by 현수빈 on 7/13/24.
//

import Foundation
import ComposableArchitecture


@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable { // test 코드에서 사용하기 위해 Equatable 준수
        var contacts: IdentifiedArrayOf<Contact> = []
        // addContact feature 연결, Presents 매크로는 optional 값을 가짐. nil이면 present x
        @Presents var addContact: AddContactFeature.State?
        
    }
    
    enum Action {
        case addButtonTapped
        // parent feature가 child feature의 모든 action 관찰 가능
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    
    // 부모 reducer는 네비게이션을 위해 자식 state를 만들 수 있고, 자식의 action을 볼 수 있어서 추가적인 로직 처리가 가능
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State(
                    contact: Contact(id: UUID(), name: "")
                )
                return .none
                
             // .addContact(.presented(.saveButtonTapped)) 이런 방식이 아닌 delegate로 변경 -> child가 직접 dismiss를 관리하면서 불필요
//            case .addContact(.presented(.delegate(.cancel))):
//                state.addContact = nil
//                return  .none
                
            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                state.contacts.append(contact)
//                state.addContact = nil
                return .none
                
            case .addContact:
                return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) { // optional인 자식 state를 자식 reducer를 부모 도메인에 포함
            AddContactFeature()
        }
    }
}
