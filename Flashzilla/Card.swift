//
//  Card.swift
//  Flashzilla
//
//  Created by 최준영 on 2023/02/13.
//
//  Card model file

import Foundation

struct Card: Hashable, Codable {
    static var key = "cardData"
    var question: String
    var answer: String
    
    static var instance = Card(question: "what's your name?", answer: "my name is choi jun yeong, just call me yeong")
}
