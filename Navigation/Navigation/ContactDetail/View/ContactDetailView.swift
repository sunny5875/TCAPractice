//
//  ContactDetailView.swift
//  Navigation
//
//  Created by 현수빈 on 7/14/24.
//

import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {
    
    @Bindable var store: StoreOf<ContactDetailFeature>
    
    var body: some View {
        Form {
            TextField(
                store.contact.name,
                text: $store.newName.sending(\.setName)
            )
            
            Button("Update") {
                store.send(.updateButtonTapped)
            }
            Button("Delete") {
                store.send(.deleteButtonTapped)
            }
        }
        .navigationTitle(Text(store.contact.name))
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
