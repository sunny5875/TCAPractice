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
        
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case alert(PresentationAction<Alert>) // alert 뜨기
        case delegate(Delegate) // alert에서 확인 누를 경우
        case deleteButtonTapped // 삭제 버튼 누를 때
        
        enum Alert {
            case confirmDeletion
        }
        enum Delegate {
            case confirmDeletion
        }
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
            case .alert:
                return .none
                
            case .delegate:
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
}
