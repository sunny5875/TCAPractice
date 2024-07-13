//
//  NavigationApp.swift
//  Navigation
//
//  Created by 현수빈 on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct NavigationApp: App {
    static let store = Store(initialState: ContactsFeature.State()) {
       ContactsFeature()
            ._printChanges()
     }
    
    var body: some Scene {
        WindowGroup {
            ContactView(store: NavigationApp.store)
        }
    }
}
