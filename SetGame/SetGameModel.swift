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
        self.startGame()
    }
    
    func newGame() {
        startGame()
    }
    
    private func startGame() {
        self.cardsInSet = [Card]()
        self.selectedCards = [Card]()
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
            let freeCards = allCards.filter { (card) -> Bool in
                return card.cardState == .free
            }
            if freeCards.count >= 3 {
                gameStatus = "3 new cards were dealt"
                let newCardsForDeck = freeCards[0..<3]
                cardsOnBoard += newCardsForDeck
                for card in newCardsForDeck {
                    allCards[allCards.index(of: card)!].cardState = .onBoard
                }
            } else {
                gameStatus = "All cards are on deck!"
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
        if checkSet(between: set) {
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
        let availableCards = allCards.filter { (card) -> Bool in
            return card.cardState == .free
        }
        if cardsOnBoard.count <= 12 && !availableCards.isEmpty {
            var availableCardsCounter = 0
            for (index,card) in cardsOnBoard.enumerated() {
                if selectedCards.contains(card) {
                    cardsOnBoard[index] = availableCards[availableCardsCounter]
                    allCards[allCards.index(of: availableCards[availableCardsCounter])!].cardState = .onBoard
                    availableCardsCounter += 1
                }
            }
        } else {
            for selectedCard in selectedCards {
                cardsOnBoard.remove(at: cardsOnBoard.index(of: selectedCard)!)
            }
        }
    }
    
    private func checkSet(between cards:[Card]) -> Bool {
        return checkSameOfDifferentValues(between: cards[0].number, cards[1].number, cards[2].number) &&
            checkSameOfDifferentValues(between: cards[0].color, cards[1].color, cards[2].color) &&
            checkSameOfDifferentValues(between: cards[0].type, cards[1].type, cards[2].type) &&
            checkSameOfDifferentValues(between: cards[0].fill, cards[1].fill, cards[2].fill)
    }
    
    private func checkSameOfDifferentValues<T: Comparable>(between element1: T, _ element2: T, _ element3: T) -> Bool {
        return ((element1 == element2)&&(element2 == element3)) ||
            ((element1 != element2)&&(element2 != element3)&&(element1 != element3))
    }
    
    func getPossibleSetCount(between cards:[Card]) -> Int {
        var combinationsCount = 0
        let cardCombinations = combinations(source: cards, takenBy: 3)
        for combination in cardCombinations {
            if checkSet(between: combination) {
                combinationsCount += 1
            }
            for card in combination {
                print("\(card.number)\(card.color)\(card.fill)\(card.type)")
            }
            print()
        }
        print(cardCombinations.count)
        return combinationsCount
    }
    
    func combinations<T>(source: [T], takenBy : Int) -> [[T]] {
        if(source.count == takenBy) {
            return [source]
        }
        
        if(source.isEmpty) {
            return []
        }
        
        if(takenBy == 0) {
            return []
        }
        
        if(takenBy == 1) {
            return source.map { [$0] }
        }
        
        var result : [[T]] = []
        
        let rest = Array(source.suffix(from: 1))
        let sub_combos = combinations(source: rest, takenBy: takenBy - 1)
        result += sub_combos.map { [source[0]] + $0 }
        
        result += combinations(source: rest, takenBy: takenBy)
        
        return result
    }

}
