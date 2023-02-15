//
//  Card.swift
//  Flashzilla
//
//  Created by 최준영 on 2023/02/13.
//
//  Card model file

import Foundation

struct Card: Hashable, Codable, Identifiable, Equatable {
    static var key = "cardData"
    var id = UUID()
    var question: String
    var answer: String
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
    
    static var instance = Card(question: "what's your name?", answer: "my name is choi jun yeong, just call me yeong")
}
