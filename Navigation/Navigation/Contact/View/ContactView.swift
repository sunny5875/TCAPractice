//
//  ContactView.swift
//  Navigation
//
//  Created by 현수빈 on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

struct ContactView: View {
  @Bindable var store: StoreOf<ContactsFeature>
  
  var body: some View {
      NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      List {
        ForEach(store.contacts) { contact in
            NavigationLink(state: ContactDetailFeature.State(contact: contact)) {
                HStack {
                    Text(contact.name)
                    Spacer()
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        store.send(.deleteButtonTapped(id: contact.id))
                    } label: {
                        Label("Trash", systemImage: "trash.circle")
                    }
                    .tint(.red)
                }
            }
        }
      }
      .navigationTitle("Contacts")
      .toolbar {
        ToolbarItem {
          Button {
            store.send(.addButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
        }
      }
      } destination: { store in
          // 여기서 path에 따른 store을 넣어서 자식 뷰 네비게이션
            ContactDetailView(store: store)
      }
    .sheet( // addContact의 state가 nil이 아니라면 AddContactFEature에 초점을 둔 store가 생성
        item: $store.scope(state: \.destination?.addContact, action: \.destination.addContact),
        content: { addContactStore in
            AddContactView(store: addContactStore)
        })
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
  }
}
