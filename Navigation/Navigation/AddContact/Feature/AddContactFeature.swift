//
//  AddContactFeature.swift
//  Navigation
//
//  Created by 현수빈 on 7/13/24.
//

import ComposableArchitecture

@Reducer
struct AddContactFeature {
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case setName(String)
        
        
        // child가 parent에게 원하는 작업을 직접 말하는 방식 으로 바꿔보자!!
        case delegate(Delegate)
        enum Delegate: Equatable {
//            case cancel <- dismiss를 직접 가지고 있게 되면서 필요없게 됨
            case saveContact(Contact)
        }
    }
    @Dependency(\.dismiss) var dismiss // child feature에서 부모 feature을 통하지 않고 dismiss 위한 값
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
//                return .send(.delegate(.cancel))
                return .run { _ in await self.dismiss() }
                
            case .saveButtonTapped:
//                return .send(.delegate(.saveContact(state.contact)))
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                }
                
            case let .setName(name):
                state.contact.name = name
                return .none
            case .delegate(_):
                return .none
            }
            
        }
    }
}
