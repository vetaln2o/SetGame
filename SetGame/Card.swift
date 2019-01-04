//
//  Cards.swift
//  SetGame
//
//  Created by Vitalij Semenenko on 1/3/19.
//  Copyright © 2019 Vitalij Semenenko. All rights reserved.
//

import Foundation

class Card {
    var type: CardType
    var number: Int
    var color: Color
    var fill: Fill
    
    enum CardType {
        case diamond
        case squiggle
        case oval
    }
    
    enum Color {
        case red
        case green
        case purple
    }
    enum Fill {
        case open
        case striped
        case solid
    }
    
    init(type: CardType, number: Int, color: Color, fill: Fill) {
        self.type = type
        self.number = number
        self.color = color
        self.fill = fill
    }
}
