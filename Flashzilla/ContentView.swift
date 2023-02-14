//
//  ContentView.swift
//  Flashzilla
//
//  Created by 최준영 on 2023/02/08.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var isVoiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    @State private var cards = [Card](repeating: Card.instance, count: 10)
    @State private var remainingTime = 100
    let timer = Timer.publish(every: 1, on: .main, in: RunLoop.Mode.common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(
                stops: [Gradient.Stop(color: .red, location: 0.0),Gradient.Stop(color: .white, location: 0.3),Gradient.Stop(color: .white, location: 0.7), Gradient.Stop(color: .green, location: 1)]),
            startPoint: .leading, endPoint: .trailing)
            .ignoresSafeArea()
            .zIndex(0)
            
            VStack {
                // Timer
                Text("\(remainingTime)")
                    .onReceive(timer) { _ in
                        guard isActive else {
                            return
                        }
                        if remainingTime > 0 {
                            remainingTime -= 1
                        }
                    }
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(isActive && cards.count-1 == index)
                        .accessibilityHidden(cards.count-1 != index)
                    }
                    
                    if cards.isEmpty {
                        Button {
                            resetCards()
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    }
                }
            }
            .zIndex(1)
            if differentWithoutColor || isVoiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count-1)
                            }
                        } label: {
                            Image(systemName: "xmark.app")
                                .resizable()
                                .scaledToFit()
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("mark your answer as being incorrect")
                        Spacer()
                        Button {
                            withAnimation {
                                removeCard(at: cards.count-1)
                            }
                        } label: {
                            Image(systemName: "checkmark.square")
                                .resizable()
                                .scaledToFit()
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("mark your answer as being correct")
                    }
                    .frame(height: 75)
                    .foregroundColor(.black.opacity(0.5))
                }
                .zIndex(2)
            }
        }
        .onChange(of: scenePhase) { _ in
            if scenePhase == .inactive, !cards.isEmpty {
                isActive = true
            } else {
                isActive = false
            }
        }
    }
    
    func removeCard(at: Int) {
        cards.remove(at: at)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        cards = [Card](repeating: Card.instance, count: 10)
        remainingTime = 100
        isActive = true
    }
}
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let distance = Double(total - position)
        return self
            .offset(CGSize(width: 0, height: 10 * distance))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
