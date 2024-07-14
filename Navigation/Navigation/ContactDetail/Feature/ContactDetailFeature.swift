//
//  ContactDetailFeature.swift
//  Navigation
//
//  Created by 현수빈 on 7/14/24.
//

import Foundation
import ComposableArchitecture


@Reducer
struct ContactDetailFeature {
    
    @ObservableState
    struct State: Equatable {
        let contact: Contact
        
        var newName: String = ""
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case alert(PresentationAction<Alert>) // alert 뜨기
        case delegate(Delegate) // alert에서 확인 누를 경우
        case deleteButtonTapped // 삭제 버튼 누를 때
        
        enum Alert {
            case confirmDeletion
            case confirmUpdate
        }
        enum Delegate {
            case confirmDeletion
            case confirmUpdate
        }
        
        case setName(String)
        case updateButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action  {
                
            case .deleteButtonTapped:
                state.alert = .confirmDeletion
                return .none
                
            case .alert(.presented(.confirmDeletion)):
                return .run { send in
                    await send(.delegate(.confirmDeletion))
                    await self.dismiss()
                }
            case .alert(.presented(.confirmUpdate)):
                return .run { send in
                    await send(.delegate(.confirmUpdate))
                    await self.dismiss()
                }
                
            case .alert:
                return .none
                
            case .delegate:
                return .none
                
                
            case let .setName(name):
                state.newName = name
                return .none
                
            case .updateButtonTapped:
                state.alert = .confirmUpdate
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
    }
}

extension AlertState where Action == ContactDetailFeature.Action.Alert {
    static let confirmDeletion = Self {
        TextState("Are you sure?")
    } actions: {
        ButtonState(role: .destructive, action: .confirmDeletion) {
            TextState("Delete")
        }
    }
    
    static let confirmUpdate = Self {
        TextState("Are you sure?")
    } actions: {
        ButtonState(role: .destructive, action: .confirmUpdate) {
            TextState("Update")
        }
    }
}
