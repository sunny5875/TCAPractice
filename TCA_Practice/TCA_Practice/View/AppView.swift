//
//  AppView.swift
//  TCA_Practice
//
//  Created by 현수빈 on 5/19/24.
//
import ComposableArchitecture
import SwiftUI


struct AppView: View {
  let store: StoreOf<AppFeature>
  
  var body: some View {
    TabView {
      CounterView(store: store.scope(state: \.tab1, action: \.tab1))
        .tabItem {
          Text("Counter 1")
        }
      
      CounterView(store: store.scope(state: \.tab2, action: \.tab2))
        .tabItem {
          Text("Counter 2")
        }
    }
  }
}
