//
//  ContentView.swift
//  TCA_Practice
//
//  Created by 현수빈 on 5/14/24.
//

import ComposableArchitecture
import SwiftUI


struct ContentView: View {
    // store: feature의 런타임을 의미, let으로 선언 가능
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped) // send로 전달 가능
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
            Button("Fact") {
                store.send(.factButtonTapped)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
            
            if store.isLoading {
                ProgressView()
            } else if let fact = store.fact {
                Text(fact)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
                   store.send(.toggleTimerButtonTapped)
                 }
                 .font(.largeTitle)
                 .padding()
                 .background(Color.black.opacity(0.1))
                 .cornerRadius(10)
        }
    }
}

#Preview {
    ContentView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature() // 여기 부분을 주석한다면 다른 버튼의 동작하지 않음. 즉 다른 기능을 하는 같은 UI가 있는 경우 다른 feature만 넣어준다면 가능!
        }
    )
}
