//
//  DeckModel.swift
//  SetGame
//
//  Created by Vitalij Semenenko on 1/5/19.
//  Copyright © 2019 Vitalij Semenenko. All rights reserved.
//

import Foundation

class Deck {
    
    var cardsList : [Card]
    
    init() {
        var cards = [Card]()
        for number in 1...3 {
            for type in Card.CardType.allCardType {
                for fill in Card.Fill.allFillTypes {
                    for color in Card.Color.allColors {
                        cards.append(Card(type: type, number: number, color: color, fill: fill))
                    }
                }
            }
        }
        cards.shuffle()
        self.cardsList = cards
    }
}
