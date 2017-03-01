//
//  HandView.swift
//  Square Off
//
//  Created by Chris Brown on 2/13/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol HandViewDataSource {
    func numberOfTiles() -> Int
    func imageForTile(at index: Int) -> UIImage?
}

protocol HandViewDelegate {
    func handViewSlotWasTapped(at index: Int)
}

class HandView: UIView {
    
    var dataSource: HandViewDataSource?
    var delegate: HandViewDelegate?
    private var handSlotImageViews: [UIImageView] = []

    func refresh() {
        // Remove previous hand
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        handSlotImageViews.removeAll()
        
        let numTiles: Int = dataSource?.numberOfTiles() ?? 0
        
        // Background image
        let backgroundFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let background = UIImageView(frame: backgroundFrame)
        background.image = #imageLiteral(resourceName: "HandSlot")
        background.contentMode = .scaleToFill
        addSubview(background)
        
        let topMargin: CGFloat = bounds.height * (5/58)
        let sideMargin: CGFloat = bounds.width * (5/254)
        let sidePadding: CGFloat = bounds.width * (6/254)
        let handSlotHeight: CGFloat = bounds.height * (48/58)
        let handSlotWidth: CGFloat = bounds.width * (44/254)
        
        for index in 0..<numTiles {
            let xPos: CGFloat = (handSlotWidth + sidePadding) * CGFloat(index) + sideMargin
            let yPos: CGFloat = topMargin
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(slotImageTapped(_:)))
            let handSlotImageView = UIImageView(frame: CGRect(x: xPos, y: yPos, width: handSlotWidth, height: handSlotHeight))
            
            handSlotImageView.isUserInteractionEnabled = true
            handSlotImageView.tag = index
            handSlotImageView.image = dataSource?.imageForTile(at: index)
            handSlotImageView.addGestureRecognizer(tapRecognizer)
            
            addSubview(handSlotImageView)
            handSlotImageViews.append(handSlotImageView)
        }
    }
    
    func slotImageTapped(_ sender: UITapGestureRecognizer) {
        if let handSlotView = sender.view {
            self.delegate?.handViewSlotWasTapped(at: handSlotView.tag)
        }
    }
    
    func animateDiscard(to point: CGPoint, callback: @escaping AnimationCallback) {
        let pointInHandView = convert(point, from: superview)
        
        let duration: TimeInterval = 0.08
        var delay: TimeInterval = 0
        var index = 0
        for handSlotImageView in self.handSlotImageViews {
            UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
                    handSlotImageView.center = pointInHandView
            }) { (finished) in
                callback(index == self.handSlotImageViews.count - 1)
                index += 1
            }
            delay += duration
        }
    }
    
    func animateDeal(from point: CGPoint, callback: @escaping AnimationCallback) {
        let pointInHandView = convert(point, from: superview)
        
        // Remove previous hand
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        handSlotImageViews.removeAll()
        
        let numTiles: Int = dataSource?.numberOfTiles() ?? 0
        
        // Background image
        let backgroundFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let background = UIImageView(frame: backgroundFrame)
        background.image = #imageLiteral(resourceName: "HandSlot")
        background.contentMode = .scaleToFill
        
        addSubview(background)
        
        // Spacing variables for placing tile image views
        let topMargin: CGFloat = bounds.height * (5/58)
        let sideMargin: CGFloat = bounds.width * (5/254)
        let sidePadding: CGFloat = bounds.width * (6/254)
        let handSlotHeight: CGFloat = bounds.height * (48/58)
        let handSlotWidth: CGFloat = bounds.width * (44/254)
        
        var centers: [CGPoint] = []
        
        // Calculate destination but add at pointInHandView
        for index in 0..<numTiles {
            let xPos: CGFloat = (handSlotWidth + sidePadding) * CGFloat(index) + sideMargin
            let yPos: CGFloat = topMargin
            var frame =  CGRect(x: xPos, y: yPos, width: handSlotWidth, height: handSlotHeight)
            centers.append(frame.center)
            frame.center = pointInHandView
            
            let handSlotImageView = UIImageView(frame: frame)
            handSlotImageView.image = dataSource?.imageForTile(at: index)
            handSlotImageView.tag = index
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.slotImageTapped))
            handSlotImageView.addGestureRecognizer(tapRecognizer)
            handSlotImageView.isUserInteractionEnabled = true
            
            handSlotImageViews.append(handSlotImageView)
            
            addSubview(handSlotImageView)
        }
        
        let duration: TimeInterval = 0.1
        var delay: TimeInterval = 0
        var index = 0
        for handSlotImageView in handSlotImageViews {
            UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
                handSlotImageView.center = centers[index]
            }) { (finished) in
                callback(index == self.handSlotImageViews.count - 1)
                
            }
            index += 1
            delay += duration
        }
    }
}
