//
//  ContentViewViewModel.swift
//  Flashzilla
//
//  Created by 최준영 on 2023/02/16.
//

import SwiftUI

@MainActor
class ContentViewViewModel: ObservableObject {
    @Published private(set) var cards: [Card]
    
    let cardsFileName = "cards.json"
    
    @Published private(set) var isActive = true
    @Published private(set) var remainingTime = 100
    let timer = Timer.publish(every: 1, on: .main, in: RunLoop.Mode.common).autoconnect()
    
    init() {
        cards = []
        loadData()
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let fileUrl = getDocumentDirectory().appendingPathComponent(cardsFileName)
        guard let data = try? Data(contentsOf: fileUrl) else {
            print("데이터가 존재하지 않거나 로딩이 실패했습니다.")
            return
        }
        guard let decoded = try? JSONDecoder().decode([Card].self, from: data) else {
            print("디코딩 과정에서 오류가 발생했습니다.")
            return
        }
        cards = decoded
    }
    
    func saveData() {
        let fileUrl = getDocumentDirectory().appendingPathComponent(cardsFileName)
        guard let encoded = try? JSONEncoder().encode(cards) else {
            print("인코딩 과정에서 문제가 발생했습니다.")
            return
        }
        do {
            try encoded.write(to: fileUrl, options: [.atomic])
        } catch {
            print("데이터 저장과정에서 문제가 발생했습니다. :\(error.localizedDescription)")
        }
    }
    
    func cardIndex(_ card: Card) -> Int {
        for i in 0..<cards.count {
            if card == cards[i] {
                return i
            }
        }
        fatalError("can not find index of card")
    }

    func removeCard(at: Int) {
        cards.remove(at: at)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func removeCard(at offset: IndexSet) {
        cards.remove(atOffsets: offset)
    }
    
    func removeFrontCard() {
        cards.remove(at: cards.count-1)
    }
    
    func appendCard(_ card: Card) {
        let newCard = Card(question: card.question, answer: card.answer)
        cards.insert(newCard, at: 0)
        isActive = true
    }
    
    func resetCards() {
        remainingTime = 100
        loadData()
        isActive = !cards.isEmpty
    }
    
    // Timer
    func discountRemainingTime() {
        remainingTime -= 1
    }
    
    func setIsActive(_ bool: Bool) {
        isActive = bool
    }
}
