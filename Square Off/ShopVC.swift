//
//  ShopVC.swift
//  Square Off
//
//  Created by Chris Brown on 2/16/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol ShopVCDataSource {
    func currentPlayer() -> Player
    func shopAnimationPoint() -> CGPoint
}

protocol ShopVCDelegate {
    func purchased(card: Card)
}

class ShopVC: UIViewController {

    var dataSource: ShopVCDataSource!
    var delegate: ShopVCDelegate!
    
    private var buyButton: UIButton!
    private var cancelButton: UIButton!
    private var tileTag: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureShop()
        showAnimate()
    }
    
    private func configureShop() {
        addBackground()
        addPopup()
        addTotalGems()
        addShop()
        addButtons()
    }
    
    private func addBackground() {
        let backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.alpha = 0.3
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAnimate))
        backgroundView.addGestureRecognizer(tapRecognizer)
        
        view.addSubview(backgroundView)
    }
    
    private func addPopup() {
        let width: CGFloat = view.bounds.width * (274/320)
        let height: CGFloat = view.bounds.height * (431/568)
        let xPos: CGFloat = view.bounds.midX - width / 2
        let yPos: CGFloat = view.bounds.midY - height / 2
        let frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        let popupView = UIView(frame: frame)
        
        popupView.backgroundColor = Colors.offWhite
        popupView.layer.cornerRadius = 8
        popupView.layer.shadowColor = Colors.font.cgColor
        popupView.layer.shadowOpacity = 0.7
        popupView.layer.shadowOffset = CGSize(width: 0, height: 8)
        popupView.layer.shadowRadius = 10
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCancelButton))
        popupView.addGestureRecognizer(tapRecognizer)
        
        view.addSubview(popupView)
    }
    
    private func addTotalGems() {
        let player = dataSource.currentPlayer()
        let totalGems = player.playerHand.totalGems()
        
        let width: CGFloat = view.bounds.width * (150/320)
        let height: CGFloat = view.bounds.height * (48/568)
        let xPos: CGFloat = view.bounds.midX - width / 2
        let yPos: CGFloat = view.bounds.height * (116.5/568) - height
        let frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        let label = UILabel(frame: frame)
        
        label.font = UIFont(name: "Anita semi-square", size: 20)
        label.textColor = Colors.font
        label.textAlignment = .center
        label.text = "Total Gems: \(totalGems)"
        
        view.addSubview(label)
    }
    
    private func addShop() {
        let player = dataSource.currentPlayer()
        let totalGems = player.playerHand.totalGems()
        let alpha: CGFloat = 0.3
        
        // Shop image
        let shopXPos: CGFloat = view.bounds.width * (31/320)
        let shopYPos: CGFloat = view.bounds.height * (116.5/568)
        let shopWidth: CGFloat = view.bounds.width * (258/320)
        let shopHeight: CGFloat = view.bounds.height * (311/568)
        let shopFrame = CGRect(x: shopXPos, y: shopYPos, width: shopWidth, height: shopHeight)
        let shopImageView = UIImageView(frame: shopFrame)
        
        shopImageView.image = #imageLiteral(resourceName: "Shop")
        
        view.addSubview(shopImageView)

        // Cards
        let topMargin: CGFloat = shopYPos + view.bounds.height * (7/568)
        let sideMargin: CGFloat = shopXPos + view.bounds.width * (7/320)
        let topPadding: CGFloat = view.bounds.height * (15/568)
        let sidePadding: CGFloat = view.bounds.width * (8/320)
        let tileWidth: CGFloat = view.bounds.width * (55/320)
        let tileHeight: CGFloat = view.bounds.height * (60/568)

        for index in 0..<16 {
            let column = index % 4
            let row = Int(index / 4)

            let xPos: CGFloat = sideMargin + CGFloat(column) * (sidePadding + tileWidth)
            let yPos: CGFloat = topMargin + CGFloat(row) * (topPadding + tileHeight)
            let frame = CGRect(x: xPos, y: yPos, width: tileWidth, height: tileHeight)

            let tileImageView = UIImageView(frame: frame)
            tileImageView.tag = column + (row * 4)
            tileImageView.isUserInteractionEnabled = true

            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tileTapped(_:)))

            switch ShopCard(rawValue: index)! {
            case .SingleGem:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "SingleGemPink") : #imageLiteral(resourceName: "SingleGemGreen")
                tileImageView.addGestureRecognizer(tapRecognizer)
            case .DoubleGem:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "DoubleGemPink") : #imageLiteral(resourceName: "DoubleGemGreen")
                if totalGems >= 3 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .TripleGem:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "TripleGemPink") : #imageLiteral(resourceName: "TripleGemGreen")
                if totalGems >= 6 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .Jump:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "JumpPink") : #imageLiteral(resourceName: "JumpGreen")
                if totalGems >= 4 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .Attack:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "AttackPink") : #imageLiteral(resourceName: "AttackGreen")
                if totalGems >= 4 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .Defend:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "DefendPink") : #imageLiteral(resourceName: "DefendGreen")
                if totalGems >= 4 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .Burn:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "BurnPink") : #imageLiteral(resourceName: "BurnGreen")
                if totalGems >= 4 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .Resurrect:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "ResurrectPink") : #imageLiteral(resourceName: "ResurrectGreen")
                if totalGems >= 6 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .SingleStraight:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "SingleStraightPink") : #imageLiteral(resourceName: "SingleStraightGreen")
                if totalGems >= 3 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .SingleDiagonal:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "SingleDiagonalPink") : #imageLiteral(resourceName: "SingleDiagonalGreen")
                if totalGems >= 3 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .ZigZagLeft:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "ZigZagLeftPink") : #imageLiteral(resourceName: "ZigZagLeftGreen")
                if totalGems >= 5 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .KnightLeft:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "KnightLeftPink") : #imageLiteral(resourceName: "KnightLeftGreen")
                if totalGems >= 5 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .DoubleStraight:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "DoubleStraightPink") : #imageLiteral(resourceName: "DoubleStraightGreen")
                if totalGems >= 4 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .DoubleDiagonal:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "DoubleDiagonalPink") : #imageLiteral(resourceName: "DoubleDiagonalGreen")
                if totalGems >= 5 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .ZigZagRight:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "ZigZagRightPink") : #imageLiteral(resourceName: "ZigZagRightGreen")
                if totalGems >= 5 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            case .KnightRight:
                tileImageView.image = player.number == 0 ? #imageLiteral(resourceName: "KnightRightPink") : #imageLiteral(resourceName: "KnightRightGreen")
                if totalGems >= 5 {
                    tileImageView.addGestureRecognizer(tapRecognizer)
                } else {
                    tileImageView.alpha = alpha
                }
            }
            
            view.addSubview(tileImageView)
        }
    }
    
    private func addButtons() {
        let width: CGFloat = view.bounds.width * (150/320)
        let height: CGFloat = view.bounds.height * (48/568)
        let xPos: CGFloat = view.bounds.midX - width / 2
        let yPos: CGFloat = view.bounds.height * (443.5/568)
        let frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        
        buyButton = UIButton(frame: frame)
        buyButton.setBackgroundImage(#imageLiteral(resourceName: "BuyButton"), for: .normal)
        buyButton.setBackgroundImage(#imageLiteral(resourceName: "BuyButtonPressed"), for: .highlighted)
        buyButton.addTarget(self, action: #selector(purchaseCardAndDismiss), for: .touchUpInside)
        buyButton.isHidden = true
        
        cancelButton = UIButton(frame: frame)
        cancelButton.setBackgroundImage(#imageLiteral(resourceName: "CancelButton"), for: .normal)
        cancelButton.setBackgroundImage(#imageLiteral(resourceName: "CancelButtonPressed"), for: .highlighted)
        cancelButton.addTarget(self, action: #selector(dismissAnimate), for: .touchUpInside)
        
        view.addSubview(buyButton)
        view.addSubview(cancelButton)
    }
    
    @objc private func showCancelButton() {
        tileTag = -1
        cancelButton.isHidden = false
        buyButton.isHidden = true
        animateButton()
    }
    
    @objc private func showBuyButton() {
        cancelButton.isHidden = true
        buyButton.isHidden = false
        animateButton()
        view.setNeedsLayout()
    }
    
    @objc private func tileTapped(_ sender: UITapGestureRecognizer) {
        if let tileImageView = sender.view as? UIImageView {
            if tileTag == tileImageView.tag {
                showCancelButton()
            } else {
                tileTag = tileImageView.tag
                showBuyButton()
            }
        }
    }
    
    @objc private func purchaseCardAndDismiss() {
        delegate.purchased(card: selectedCard())
        dismissAnimate()
    }
    
    private func selectedCard() -> Card {
        let player = dataSource.currentPlayer()
        
        switch ShopCard(rawValue: tileTag)! {
        case .SingleGem:
            return GemCard(player: player, gem: Gem.Single)
        case .DoubleGem:
            return GemCard(player: player, gem: Gem.Double)
        case .TripleGem:
            return GemCard(player: player, gem: Gem.Triple)
        case .Jump:
            return JumpCard(player: player)
        case .Attack:
            return AttackCard(player: player)
        case .Defend:
            return DefendCard(player: player)
        case .Burn:
            return BurnCard(player: player)
        case .Resurrect:
            return ResurrectCard(player: player)
        case .SingleStraight:
            return SingleStraightCard(player: player)
        case .SingleDiagonal:
            return SingleDiagonalCard(player: player)
        case .ZigZagLeft:
            return ZigZagLeftCard(player: player)
        case .KnightLeft:
            return KnightLeftCard(player: player)
        case .DoubleStraight:
            return DoubleStraightCard(player: player)
        case .DoubleDiagonal:
            return DoubleDiagonalCard(player: player)
        case .ZigZagRight:
            return ZigZagRightCard(player: player)
        case .KnightRight:
            return KnightRightCard(player: player)
        }
    }
    
    private func animateButton() {
        let duration: TimeInterval = 0.1
        let scale: CGFloat = 1.1
        
        UIButton.animate(withDuration: duration, animations: { 
            self.buyButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.cancelButton.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { (finished) in
            self.buyButton.transform = CGAffineTransform.identity
            self.cancelButton.transform = CGAffineTransform.identity
        }
    }
    
    private func showAnimate() {
        let destination = view.center
        view.center = dataSource.shopAnimationPoint()
        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        view.alpha = 0
        UIView.animate(withDuration: 0.25) { 
            self.view.center = destination
            self.view.alpha = 1
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func dismissAnimate() {
        let destination = dataSource.shopAnimationPoint()
        
        UIView.animate(withDuration: 0.25, animations: { 
            self.view.center = destination
            self.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            self.view.alpha = 0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }

}
