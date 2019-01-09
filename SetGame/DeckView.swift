//
//  DeckView.swift
//  SetGame
//
//  Created by Vitalij Semenenko on 1/4/19.
//  Copyright © 2019 Vitalij Semenenko. All rights reserved.
//

import UIKit

@IBDesignable
class DeckView: UIView {
    
    var deck = [Card]() {
        didSet {
            for subview in self.subviews {
                subview.removeFromSuperview()
            }
            setNeedsLayout()
        }
    }
    private var cellsCount = 12
    private var cellsRects = [CGRect]()
    
    var lastSelectedCard: Card?
    
    private func calculateCellsRects() -> [CGRect] {
        var cells = [CGRect]()
        let minimumCellWidth = (bounds.width*0.87) / 4
        let minimumCellHeight = minimumCellWidth * 6 / 5
        let cellSize = CGSize(width: minimumCellWidth, height: minimumCellHeight)
        let columnsCount = 4
        let rowsCount = Int(bounds.height / minimumCellHeight)
        let dxdy = bounds.width * 0.13 / CGFloat(columnsCount)
        for row in 0..<rowsCount {
            for col in 0..<columnsCount {
                let origin = CGPoint(x: dxdy*CGFloat(col)+CGFloat(col)*minimumCellWidth, y: dxdy*CGFloat(row)+CGFloat(row)*minimumCellHeight)
                cells.append(CGRect(origin: origin, size: cellSize))
            }
        }
        return cells
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        let cardsGrid = calculateCellsRects()
        for (index,card) in deck.enumerated() {
            if index < cardsGrid.count {
                let newCard = CardView(card: card, in: cardsGrid[index])
                newCard.backgroundColor = .clear
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCard(recognizedBy:)))
                newCard.addGestureRecognizer(tapGesture)
                self.addSubview(newCard)
            } else {
                break
            }
        }
    }
    
    func updateViewFromModel() {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    @objc func tapCard(recognizedBy recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view as? CardView {
                lastSelectedCard = cardView.card
                NotificationCenter.default.post(name: Notification.Name.CardWasSelect, object: self)
            }
        default: break
        }
    }

}

extension Notification.Name {
    static let CardWasSelect = Notification.Name("CardWasSelect")
}
