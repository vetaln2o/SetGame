//
//  CardView.swift
//  SetGame
//
//  Created by Vitalij Semenenko on 1/3/19.
//  Copyright © 2019 Vitalij Semenenko. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable
    var symbol : Int = 1 {
        didSet {
            switch symbol {
            case 1 : card.type = .diamond
            case 2 : card.type = .oval
            case 3 : card.type = .squiggle
            default: break
            }
        }
    }
    
    @IBInspectable
    var number : Int = 1 {
        didSet {
            card.number = number
        }
    }
    
    @IBInspectable
    var color : Int = 1 {
        didSet {
            switch color {
            case 1: card.color = .red
            case 2: card.color = .green
            case 3: card.color = .purple
            default: break
            }
        }
    }
    
    @IBInspectable
    var fill : Int = 1 {
        didSet {
            switch fill {
            case 1 : card.fill = .open
            case 2 : card.fill = .solid
            case 3 : card.fill = .striped
            default: break
            }
        }
    }
    
    var card = Card(type: .diamond, number: 3, color: .red, fill: .striped)
    
    init(card: Card, in rect: CGRect) {
        super.init(frame: rect)
        self.card = card
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let roundRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.height*0.1)
        roundRect.addClip()
        UIColor.white.setFill()
        roundRect.fill()
        switch card.cardState {
        case .inSet:
            roundRect.lineWidth = bounds.width / 20
            UIColor.green.setStroke()
            roundRect.stroke()
        case .isSelected:
            roundRect.lineWidth = bounds.width / 20
            UIColor.blue.setStroke()
            roundRect.stroke()
        default: break
        }
        drawSymbols()
    }
    
    private func getSymbolRects() -> [CGRect] {
        var symbolRects = [CGRect]()

        let pipHeight = bounds.height / 6
        let pipWidgth = bounds.width * 0.75
        let pipSize = CGSize(width: pipWidgth, height: pipHeight)
        let pipOrigin = CGPoint(x: (bounds.width - pipWidgth)/2, y: bounds.midY-pipHeight/2)
        
        switch card.number {
        case 1:
            symbolRects.append(CGRect(origin: pipOrigin, size: pipSize))
        case 2:
            symbolRects.append(CGRect(origin: CGPoint(x: pipOrigin.x, y: pipOrigin.y+pipSize.height/2+5), size: pipSize))
            symbolRects.append(CGRect(origin: CGPoint(x: pipOrigin.x, y: pipOrigin.y-pipSize.height/2-5), size: pipSize))
        case 3:
            symbolRects.append(CGRect(origin: pipOrigin, size: pipSize))
            symbolRects.append(CGRect(origin: CGPoint(x: pipOrigin.x, y: pipOrigin.y+pipSize.height+5), size: pipSize))
            symbolRects.append(CGRect(origin: CGPoint(x: pipOrigin.x, y: pipOrigin.y-pipSize.height-5), size: pipSize))
        default: break
        }

        return symbolRects
    }
    
    private func drawSymbols() {
        let symbol = UIBezierPath()
        for symbolPlace in getSymbolRects() {
            switch card.type {
            case .oval :
                let oval = UIBezierPath(roundedRect: symbolPlace, cornerRadius: symbolPlace.height*0.6)
                symbol.append(oval)
            case .diamond :
                let diamond = UIBezierPath()
                diamond.move(to: CGPoint(x: symbolPlace.minX, y: symbolPlace.midY))
                diamond.addLine(to: CGPoint(x: symbolPlace.midX, y: symbolPlace.minY))
                diamond.addLine(to: CGPoint(x: symbolPlace.maxX, y: symbolPlace.midY))
                diamond.addLine(to: CGPoint(x: symbolPlace.midX, y: symbolPlace.maxY))
                diamond.close()
                symbol.append(diamond)

            case .squiggle :
                let squiggle = UIBezierPath()
                let sqdx = symbolPlace.width * 0.1
                let sqdy = symbolPlace.height * 0.2
                squiggle.move(to: CGPoint(x: symbolPlace.minX, y: symbolPlace.midY))
                squiggle.addCurve(
                    to: CGPoint(x: symbolPlace.minX + symbolPlace.width / 2, y: symbolPlace.minY + symbolPlace.height / 8),
                    controlPoint1: CGPoint(x: symbolPlace.minX, y: symbolPlace.minY),
                    controlPoint2: CGPoint(x: symbolPlace.minX + symbolPlace.width / 2 - sqdx, y: symbolPlace.minY + symbolPlace.height / 8 - sqdy))
                squiggle.addCurve(
                    to: CGPoint(x: symbolPlace.minX + symbolPlace.width * 4/5, y: symbolPlace.minY + symbolPlace.height / 8),
                    controlPoint1: CGPoint(x: symbolPlace.minX + symbolPlace.width / 2 + sqdx, y: symbolPlace.minY + symbolPlace.height / 8 + sqdy),
                    controlPoint2: CGPoint(x: symbolPlace.minX + symbolPlace.width * 4/5 - sqdx, y: symbolPlace.minY + symbolPlace.height / 8 + sqdy))
                squiggle.addCurve(
                    to: CGPoint(x: symbolPlace.minX + symbolPlace.width, y: symbolPlace.minY + symbolPlace.height / 2),
                    controlPoint1: CGPoint(x: symbolPlace.minX + symbolPlace.width * 4/5 + sqdx, y: symbolPlace.minY + symbolPlace.height / 8 - sqdy),
                    controlPoint2: CGPoint(x: symbolPlace.minX + symbolPlace.width, y: symbolPlace.minY))
                
                let lowerSquiggle = UIBezierPath(cgPath: squiggle.cgPath)
                lowerSquiggle.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi))
                lowerSquiggle.apply(CGAffineTransform.identity.translatedBy(x: bounds.width, y: bounds.height))
                squiggle.move(to: CGPoint(x: symbolPlace.minX, y: symbolPlace.midY))
                squiggle.append(lowerSquiggle)

                symbol.append(squiggle)
            }
        }
        symbol.addClip()
        fillSymbol(symbol, with: getColor())
    }
    
    private func fillSymbol(_ symbol: UIBezierPath, with color: UIColor) {
        switch card.fill {
        case .solid:
            color.setFill()
            symbol.fill()
        case .open:
            symbol.lineWidth = bounds.width / 20
            color.setStroke()
            symbol.stroke()
        case .striped:
            let stripedLines = UIBezierPath()
            let dashes : [CGFloat] = [1,2]
            stripedLines.setLineDash(dashes, count: dashes.count, phase: 0.0)
            stripedLines.lineWidth = bounds.size.height
            stripedLines.lineCapStyle = .butt
            stripedLines.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
            stripedLines.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
            color.setStroke()
            stripedLines.stroke()
            symbol.lineWidth = bounds.width / 20
            symbol.stroke()
            symbol.append(stripedLines)
        }
    }
    
    private func getColor() -> UIColor {
        switch card.color {
        case .green : return UIColor.green
        case .purple : return UIColor.purple
        case .red : return UIColor.red
        }
    }

}
