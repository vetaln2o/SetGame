//
//  ViewController.swift
//  SetGame
//
//  Created by Vitalij Semenenko on 1/3/19.
//  Copyright © 2019 Vitalij Semenenko. All rights reserved.
//

import UIKit

class SetGame: UIViewController {
    
    @IBOutlet weak var cardsDeck: DeckView!
    @IBOutlet weak var scoresLabel: UILabel!
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    @IBOutlet weak var dealButton: UIButton!
    
    
    var game = SetGameModel()
    
    var cardObserver: NSObjectProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsDeck.deck = game.cardsOnBoard
        
        cardObserver = NotificationCenter.default.addObserver(
            forName: .CardWasSelect,
            object: cardsDeck,
            queue: OperationQueue.main,
            using: { [unowned self] (notification) in
                self.game.selectCard(card: (self.cardsDeck.lastSelectedCard)!)
                self.cardsDeck.deck = self.game.cardsOnBoard
                self.updateLables()
//                for card in self.game.cardsOnBoard {
//                    print("\(card.number) \(card.color) \(card.fill) \(card.type) \(card.cardState)")
//                }
//                print()
        })
        
        cardObserver = NotificationCenter.default.addObserver(
            forName: .GameOver,
            object: game,
            queue: OperationQueue.main,
            using: { (notification) in
                self.showGameOverAlert()
        })
        
    }

    @IBAction func newGame(_ sender: UIButton? = nil) {
        game = SetGameModel()
        cardsDeck.deck = game.cardsOnBoard
        updateLables()
    }
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.dealMoewCards()
        cardsDeck.deck = game.cardsOnBoard
        updateLables()
    }
    @IBAction func showHint(_ sender: UIButton) {
        let possibleSetCounts = game.getPossibleSetCount(between: game.cardsOnBoard)
        if possibleSetCounts != 0 {
            gameStatus.text = "You have \(possibleSetCounts) possible sets on board!"
        } else if !game.freeCards.isEmpty {
            gameStatus.text = "Deal more cards to find Set!"
        }
    }
    
    private func updateLables() {
        deckLabel.text = "Deck: \(game.allCards.count - game.cardsInSet.count)"
        scoresLabel.text = "Scores: \(game.scores) / \(game.tryingCount)"
        gameStatus.text = game.gameStatus
        if game.cardsOnBoard.count == 24 {
            dealButton.isEnabled = false
        } else {
            dealButton.isEnabled = true

        }
    }
    
    private func showGameOverAlert() {
        let alert = UIAlertController(title: "WIN!", message: "All sets were found. Your scores are \(game.scores) for \(game.tryingCount) attempts. \(game.cardsOnBoard.count) cards left.", preferredStyle: .alert)
        let newGameAction = UIAlertAction(title: "New Game", style: .default) { (action) in
            self.newGame()
        }
        alert.addAction(newGameAction)
        self.present(alert, animated: true)
    }

}

