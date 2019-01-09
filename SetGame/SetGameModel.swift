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
    
    private var dealPlace = 12
    
    func dealMoewCards() {
        let freeCards = allCards.filter { (card) -> Bool in
            return card.cardState == .free
        }
        if !freeCards.isEmpty {
            cardsOnBoard += freeCards[dealPlace..<dealPlace+3]
            dealPlace += 3
        }
    }
    
    func selectCard(card: Card) {
        if let cardIndex = allCards.index(of: card) {
            if !selectedCards.contains(allCards[cardIndex]) {
                allCards[cardIndex].cardState = .isSelected
                selectedCards.append(allCards[cardIndex])
            } else {
                allCards[cardIndex].cardState = .free
                selectedCards.remove(at: selectedCards.index(of:card)!)
            }
        }
        if selectedCards.count == 3 {
            print("check set!")
            print(cardsInSet)
            print(selectedCards)
            checkPossible(set: selectedCards)
            print(cardsInSet)
            print(selectedCards)
        }
    }
    
    private func checkPossible(set: [Card]) {
        if checkSameOfDifferentValues(between: set[0].number, set[1].number, set[2].number) &&
            checkSameOfDifferentValues(between: set[0].color, set[1].color, set[2].color) &&
            checkSameOfDifferentValues(between: set[0].type, set[1].type, set[2].type) &&
            checkSameOfDifferentValues(between: set[0].fill, set[1].fill, set[2].fill) {
            print("isSet")
            for selectedCard in selectedCards {
                if let index = allCards.index(of: selectedCard) {
                    allCards[index].cardState = .inSet
                }
            }
            cardsInSet += selectedCards
        } else {
            print("isNotSet")
            for selectedCard in selectedCards {
                if let index = allCards.index(of: selectedCard) {
                    allCards[index].cardState = .free
                }
            }
        }

        selectedCards.removeAll()
    }
    
    private func checkSameOfDifferentValues<T: Comparable>(between element1: T, _ element2: T, _ element3: T) -> Bool {
        return ((element1 == element2)&&(element2 == element3)) ||
            ((element1 != element2)&&(element2 != element3)&&(element1 != element3))
    }

}
