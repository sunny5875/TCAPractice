//
//  TCA_PracticeApp.swift
//  TCA_Practice
//
//  Created by 현수빈 on 5/14/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_PracticeApp: App {
    // store은 무조건적으로 한번만 만들어져야 함
    static let store = Store(initialState: AppFeature.State()) {
       AppFeature()
     }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: TCA_PracticeApp.store)
        }
    }
}
