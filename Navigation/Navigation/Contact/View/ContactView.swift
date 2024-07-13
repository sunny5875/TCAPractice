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
    NavigationStack {
      List {
        ForEach(store.contacts) { contact in
          Text(contact.name)
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
    }
    .sheet( // addContact의 state가 nil이 아니라면 AddContactFEature에 초점을 둔 store가 생성
        item: $store.scope(state: \.addContact, action: \.addContact),
        content: { addContactStore in
            AddContactView(store: addContactStore)
        })
  }
}