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
    
    enum CardType: Comparable {
        static func < (lhs: Card.CardType, rhs: Card.CardType) -> Bool {
            return lhs != rhs
        }
        
        case diamond
        case squiggle
        case oval
        
        static let allCardType : [CardType] = [.diamond, .squiggle, .oval]
    }
    
    enum Color: Comparable {
        static func < (lhs: Card.Color, rhs: Card.Color) -> Bool {
            return lhs != rhs
        }
        
        case red
        case green
        case purple
        
        static let allColors : [Color] = [.red, .green, .purple]
    }
    enum Fill: Comparable {
        static func < (lhs: Card.Fill, rhs: Card.Fill) -> Bool {
            return lhs != rhs
        }
        
        case open
        case striped
        case solid
        
        static let allFillTypes : [Fill] = [.open, .striped, .solid]
    }
    
    enum CardState {
        case free
        case onBoard
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
