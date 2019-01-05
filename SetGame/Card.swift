//
//  Cards.swift
//  SetGame
//
//  Created by Vitalij Semenenko on 1/3/19.
//  Copyright © 2019 Vitalij Semenenko. All rights reserved.
//

import Foundation

class Card: Equatable {
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return (lhs.color == rhs.color)&&(lhs.fill == rhs.fill)&&(lhs.number == rhs.number)&&(lhs.type == rhs.type)
    }
    
    var type: CardType
    var number: Int
    var color: Color
    var fill: Fill
    var cardState: CardState = .free
    
    enum CardType {
        case diamond
        case squiggle
        case oval
        
        static let allCardType : [CardType] = [.diamond, .squiggle, .oval]
    }
    
    enum Color {
        case red
        case green
        case purple
        
        static let allColors : [Color] = [.red, .green, .purple]
    }
    enum Fill {
        case open
        case striped
        case solid
        
        static let allFillTypes : [Fill] = [.open, .striped, .solid]
    }
    
    enum CardState {
        case free
        case isSelected
        case inSet
    }
    
    init(type: CardType, number: Int, color: Color, fill: Fill) {
        self.type = type
        self.number = number
        self.color = color
        self.fill = fill
    }
}
