//
//  CardView.swift
//  Flashzilla
//
//  Created by 최준영 on 2023/02/13.
//

import SwiftUI


struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var isVoiceOverEnabled
    var card: Card
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var remove: (() -> ())? = nil
    var append: ((Card) -> ())? = nil
 
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white.opacity(1-Double(abs(offset.width / 50))))
                .shadow(radius: 10)
                .background(RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(immediateColor())
                )
            VStack {
                if isVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.question)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.question)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .opacity(2.5-abs(Double(offset.width / 50)))
        .offset(CGSize(width: offset.width*3, height: 0))
        .gesture(
            DragGesture()
                .onChanged { value in
                    feedback.prepare()
                    offset = value.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 130 {
                        remove?()
                        if offset.width < 0 {
                            // haptick occurs when user drag card to failure
                            feedback.notificationOccurred(.error)
                            // pushing back a card
                            append?(card)
                        }
                    } else {
                        offset = .zero
                    }
                }
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    isShowingAnswer.toggle()
                }
        )
        .accessibilityAddTraits(.isButton)
        .animation(.spring(), value: offset)
    }
    
    func immediateColor() -> Color {
        if differentWithoutColor {
            return .white
        }
        let offsetWidth = offset.width
        if offsetWidth < 0 {
            return .red
        } else if offsetWidth == 0 {
            return .white
        } else {
            return .green
        }
    }
}



struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.instance)
    }
}
