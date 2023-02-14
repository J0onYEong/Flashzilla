//
//  ContentView.swift
//  Flashzilla
//
//  Created by 최준영 on 2023/02/08.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentWithoutColor
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
                    }
                }
            }
            if differentWithoutColor {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "xmark.app")
                            .resizable()
                            .scaledToFit()
                        Spacer()
                        Image(systemName: "checkmark.square")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(height: 75)
                    .foregroundColor(.black.opacity(0.5))
                }
            }
        }
        .onChange(of: scenePhase) { _ in
            if scenePhase == .inactive {
                isActive = true
            } else {
                isActive = false
            }
        }
    }
    
    func removeCard(at: Int) {
        cards.remove(at: at)
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
