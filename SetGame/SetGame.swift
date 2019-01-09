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
    
    
    var game = SetGameModel()
    
    var selectCardObserver: NSObjectProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsDeck.deck = game.cardsOnBoard
        
        selectCardObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.CardWasSelect,
            object: cardsDeck,
            queue: OperationQueue.main,
            using: { [unowned self] (notification) in
                self.game.selectCard(card: (self.cardsDeck.lastSelectedCard)!)
                self.cardsDeck.updateViewFromModel()
                self.updateLables()
        })
        
    }

    @IBAction func newGame(_ sender: UIButton) {
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
    }
    
    private func updateLables() {
        deckLabel.text = "Deck: \(game.allCards.count - game.cardsInSet.count)"
        scoresLabel.text = "Scores: \(game.scores) / \(game.tryingCount)"
        gameStatus.text = game.gameStatus
    }
    

}

