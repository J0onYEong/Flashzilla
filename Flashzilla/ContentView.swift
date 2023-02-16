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
    @StateObject var viewModel = ContentViewViewModel()
    // two way binding
    @State private var isShowingEditView = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(
                stops: [Gradient.Stop(color: .red, location: 0.0),Gradient.Stop(color: .white, location: 0.3),Gradient.Stop(color: .white, location: 0.7), Gradient.Stop(color: .green, location: 1)]),
                           startPoint: .leading, endPoint: .trailing)
            .ignoresSafeArea()
            .zIndex(0)
            
            VStack {
                // Timer
                Text("\(viewModel.remainingTime)")
                    .onReceive(viewModel.timer) { _ in
                        guard viewModel.isActive else {
                            return
                        }
                        if viewModel.remainingTime > 0 {
                            viewModel.discountRemainingTime()
                        }
                    }
                ZStack {
                    ForEach(viewModel.cards) { card in
                        let index = viewModel.cardIndex(card)
                        CardView(card: card) {
                            withAnimation { viewModel.removeCard(at: index) }
                        } append: { card in withAnimation { viewModel.appendCard(card) }}
                            .stacked(at: index, in: viewModel.cards.count)
                            .allowsHitTesting(viewModel.isActive && viewModel.cards.count-1 == index)
                            .accessibilityHidden(viewModel.cards.count-1 != index)
                    }
                    
                    if viewModel.cards.isEmpty {
                        VStack {
                            Text("버튼을 눌러도 게임이 시작되지 않으면 카드를 추가해 주세요")
                            Button {
                                viewModel.resetCards()
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
            }
            .zIndex(1)
            if differentWithoutColor || isVoiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.removeFrontCard()
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
                                viewModel.removeFrontCard()
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
            VStack {
                HStack {
                    Spacer()
                    Button {
                        isShowingEditView = true
                    } label: {
                        Label("Edit card", systemImage: "plusminus.circle")
                            .foregroundColor(.indigo)
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .onChange(of: scenePhase) { _ in
            viewModel.setIsActive(scenePhase == .inactive && !viewModel.cards.isEmpty)
        }
        .onAppear(perform: viewModel.resetCards)
        .sheet(isPresented: $isShowingEditView, onDismiss: viewModel.resetCards) {
            Editview(viewModel: viewModel)
        }
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
