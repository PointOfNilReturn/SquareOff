//
//  Player.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class Player {
    let number: Int
    let name: String
    let direction: Int
    
    var deadPawns: Int = 0
    var playerBag: PlayerBag
    var playerHand: PlayerHand
    var playerDiscard: PlayerDiscard
    
    init(number: Int, name: String) {
        self.number = number
        self.name = name
        direction = number == 0 ? 1 : -1
        playerBag = PlayerBag()
        playerHand = PlayerHand()
        playerDiscard = PlayerDiscard()
        
        
        // Draw first hand
        playerBag.player = self
        playerBag.populateInitialBag()
//        playerHand.newHand(for: self)
    }
    
}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.number == rhs.number
}
