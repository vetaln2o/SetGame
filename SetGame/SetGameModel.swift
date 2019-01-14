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
    
    var scores = 0
    var tryingCount = 0
    var gameStatus = "Game started!"
    
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
        cardsInSet = [Card]()
        selectedCards = [Card]()
        var visibleCards = [Card]()
        for index in 0..<12 {
            allCards[index].cardState = .onBoard
            visibleCards.append(allCards[index])
        }
        self.cardsOnBoard = visibleCards
    }
    
    func dealMoewCards() {
        let cardsOnBoardCount = cardsOnBoard.count
        if cardsOnBoardCount < 24 {
            gameStatus = "3 new cards were dealt"
            let freeCards = allCards.filter { (card) -> Bool in
                return card.cardState == .free
            }
            if !freeCards.isEmpty {
                let newCardsForDeck = freeCards[cardsOnBoardCount..<cardsOnBoardCount+3]
                cardsOnBoard += newCardsForDeck
                for card in newCardsForDeck {
                    allCards[allCards.index(of: card)!].cardState = .onBoard
                }
            }
        } else {
            gameStatus = "The deck is full!"
        }
    }
    
    func selectCard(card: Card) {
        if let cardIndex = allCards.index(of: card) {
            if !selectedCards.contains(allCards[cardIndex]) {
                allCards[cardIndex].cardState = .isSelected
                selectedCards.append(allCards[cardIndex])
            } else {
                allCards[cardIndex].cardState = .onBoard
                selectedCards.remove(at: selectedCards.index(of:card)!)
            }
        }
        if selectedCards.count == 3 {
            tryingCount += 1
            checkPossible(set: selectedCards)
        } else {
            gameStatus = "Choose more cards to find Set!"
        }
    }
    
    private func checkPossible(set: [Card]) {
        if checkSameOfDifferentValues(between: set[0].number, set[1].number, set[2].number) &&
            checkSameOfDifferentValues(between: set[0].color, set[1].color, set[2].color) &&
            checkSameOfDifferentValues(between: set[0].type, set[1].type, set[2].type) &&
            checkSameOfDifferentValues(between: set[0].fill, set[1].fill, set[2].fill) {
            for selectedCard in selectedCards {
                if let index = allCards.index(of: selectedCard) {
                    allCards[index].cardState = .inSet
                }
            }
            cardsInSet += selectedCards
            scores += 3
            gameStatus = "SET was found!"
            addNewCardInsteadOfSelected()
        } else {
            for selectedCard in selectedCards {
                if let index = allCards.index(of: selectedCard) {
                    allCards[index].cardState = .onBoard
                }
            }
            scores -= 1
            gameStatus = "No set was found :("
        }

        selectedCards.removeAll()
    }
    
    private func addNewCardInsteadOfSelected() {
        if cardsOnBoard.count <= 12 {
            let availableCards = allCards.filter { (card) -> Bool in
                return card.cardState == .free
            }
            var availableCardsCounter = 0
            for (index,card) in cardsOnBoard.enumerated() {
                if selectedCards.contains(card) {
                    cardsOnBoard[index] = availableCards[availableCardsCounter]
                    availableCardsCounter += 1
                    allCards[allCards.index(of: availableCards[availableCardsCounter])!].cardState = .onBoard
                }
            }
        } else {
            for selectedCard in selectedCards {
                cardsOnBoard.remove(at: cardsOnBoard.index(of: selectedCard)!)
            }
        }
    }
    
    private func checkSameOfDifferentValues<T: Comparable>(between element1: T, _ element2: T, _ element3: T) -> Bool {
        return ((element1 == element2)&&(element2 == element3)) ||
            ((element1 != element2)&&(element2 != element3)&&(element1 != element3))
    }

}
