//
//  AddContactView.swift
//  Navigation
//
//  Created by 현수빈 on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

struct AddContactView: View {
    // @Observable 키워드를 붙인 모델을 사용하는 쪽에는 @Bindable을 사용하여 바인딩
    @Bindable var store: StoreOf<AddContactFeature>
    
    var body: some View {
        NavigationView {
            Form {
                TextField(
                    "Name",
                    text: $store.contact.name.sending(\.setName)
                )
                
                Button("Save") {
                    store.send(.saveButtonTapped)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        store.send(.cancelButtonTapped)
                    }
                }
            }
        }
    }
}
