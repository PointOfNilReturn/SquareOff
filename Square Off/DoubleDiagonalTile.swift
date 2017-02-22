//
//  DoubleDiagonalTile.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class DoubleDiagonalTile: Tile, MovementTile {
    
    func getPaths(_ baseCoordinate: BoardCoordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-left
        if  let midCoordinate = try? BoardCoordinate(column: baseCoordinate.column - 1,
                                                     row: baseCoordinate.row - (1 * player.direction)) {
            if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column - 2,
                                                           row: baseCoordinate.row - (2 * player.direction)) {
                paths.append(Path(coordinates: [baseCoordinate, midCoordinate, targetCoordinate]))
            }
        }
        
        // Try to append Path vertical-right
        if  let midCoordinate = try? BoardCoordinate(column: baseCoordinate.column + 1,
                                                     row: baseCoordinate.row - (1 * player.direction)) {
            if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column + 2,
                                                           row: baseCoordinate.row - (2 * player.direction)) {
                paths.append(Path(coordinates: [baseCoordinate, midCoordinate, targetCoordinate]))
            }
        }
        
        return paths
    }
    
    init(player: Player) {
        let image = player.number == 0 ? #imageLiteral(resourceName: "DoubleDiagonalPink") : #imageLiteral(resourceName: "DoubleDiagonalGreen")
        super.init(player: player, cost: 5, image: image)
    }
}