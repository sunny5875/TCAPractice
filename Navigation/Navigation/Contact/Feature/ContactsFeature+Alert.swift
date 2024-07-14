//
//  ContactsFeature+.swift
//  NavigationTests
//
//  Created by 현수빈 on 7/14/24.
//

import ComposableArchitecture
import Foundation


extension AlertState where Action == ContactsFeature.Action.Alert {
    static func deleteConfirmation(id: UUID) -> Self {
       Self {
         TextState("Are you sure?")
       } actions: {
         ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
           TextState("Delete")
         }
       }
     }
}
