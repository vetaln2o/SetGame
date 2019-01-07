//
//  SetGameModel.swift
//  SetGame
//
//  Created by Vitalij Semenenko on 1/6/19.
//  Copyright © 2019 Vitalij Semenenko. All rights reserved.
//

import Foundation

class SetGameModel {
    
    var allCards = Deck().cardsList
    
    var cardsOnBoard = [Card]()
    var cardsInSet = [Card]()
    var selectedCards = [Card]()
    
    init() {
        self.cardsInSet = [Card]()
        self.selectedCards = [Card]()
        var visibleCards = [Card]()
        for index in 0..<12 {
            allCards[index].cardState = .onBoard
            visibleCards.append(allCards[index])
        }
        self.cardsOnBoard = visibleCards
    }
    
    func newGame() {
        allCards = Deck().cardsList
        cardsOnBoard = [Card]()
        cardsInSet = [Card]()
        selectedCards = [Card]()
    }
    
    func dealMoewCards() {
        let freeCards = allCards.filter { (card) -> Bool in
            return card.cardState == .free
        }
        print(freeCards.count)
        if !freeCards.isEmpty {
            cardsOnBoard += freeCards[0...2]
        }
        print(cardsOnBoard.count)
    }
    
    func selectCard(card: Card) {
        if let cardIndex = allCards.index(of: card) {
            allCards[cardIndex].cardState = .isSelected
            selectedCards.append(allCards[cardIndex])
        }
        if selectedCards.count == 3 {
            print("check set!")
            if checkPossible(set: selectedCards) {
                cardsInSet += selectedCards
                selectedCards.removeAll()
            }
        }
    }
    
    private func checkPossible(set: [Card]) -> Bool {
        var isSet = false
        if checkSameOfDifferentValues(between: set[0].number, set[1].number, set[2].number) &&
            checkSameOfDifferentValues(between: set[0].color, set[1].color, set[2].color) &&
            checkSameOfDifferentValues(between: set[0].type, set[1].type, set[2].type) &&
            checkSameOfDifferentValues(between: set[0].fill, set[1].fill, set[2].fill) {
            print("isSet")
        } else {
            print("isNotSet")
        }
        for selectedCard in selectedCards {
            if let index = allCards.index(of: selectedCard) {
                allCards[index].cardState = .inSet
            }
        }
        selectedCards.removeAll()
        return isSet
    }
    
    private func checkSameOfDifferentValues<T: Comparable>(between element1: T, _ element2: T, _ element3: T) -> Bool {
        return ((element1 == element2)&&(element2 == element3)) ||
            ((element1 != element2)&&(element2 != element3)&&(element1 != element3))
    }

}
