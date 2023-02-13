//
//  ContentView.swift
//  Flashzilla
//
//  Created by 최준영 on 2023/02/08.
//

import SwiftUI

struct ContentView: View {
    
    @State private var cards = [Card](repeating: Card.instance, count: 10)
    
    var body: some View {
        ZStack {
            VStack {
                // Timer
                
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
