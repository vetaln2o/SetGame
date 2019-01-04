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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func newGame(_ sender: UIButton) {
    }
    @IBAction func dealMoreCards(_ sender: UIButton) {
    }
    @IBAction func showHint(_ sender: UIButton) {
    }
    

}

