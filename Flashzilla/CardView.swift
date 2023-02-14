//
//  CardView.swift
//  Flashzilla
//
//  Created by 최준영 on 2023/02/13.
//

import SwiftUI


struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentWithoutColor
    
    var card: Card
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    var remove: (() -> ())? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white.opacity(1-Double(abs(offset.width / 50))))
                .shadow(radius: 10)
                .background(RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(differentWithoutColor ? .white : offset.width < 0 ? .red : .green))
            VStack {
                Text(card.question)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.gray)
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
                    offset = value.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 130 {
                        // view is transparent
                        remove?()
                    } else {
                        withAnimation {
                            offset = .zero
                        }
                    }
                }
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    isShowingAnswer.toggle()
                }
        )
    }
}



struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.instance)
    }
}
