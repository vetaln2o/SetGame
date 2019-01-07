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
    
    var game = SetGameModel()
    
    var selectCardObserver: NSObjectProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsDeck.deck = game.cardsOnBoard
        
        selectCardObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.CardWasSelect,
            object: cardsDeck,
            queue: OperationQueue.main,
            using: { [weak self] (notification) in
                print("using observer")
                self?.game.selectCard(card: (self?.cardsDeck.lastSelectedCard)!)
        })
        
    }

    @IBAction func newGame(_ sender: UIButton) {
        game = SetGameModel()
        cardsDeck.deck = game.cardsOnBoard
    }
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.dealMoewCards()
        cardsDeck.deck = game.cardsOnBoard
    }
    @IBAction func showHint(_ sender: UIButton) {
    }
    

}

