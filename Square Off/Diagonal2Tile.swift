//
//  Diagonal2Tile.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class Diagonal2Tile: Tile, MovementTile {
    
    func getPaths(baseCoordinate: BoardCoordinate, player: Player) -> [Path] {
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
    
    init() {
        super.init(cost: 5, imageName: "Diagonal2Tile")
    }
}
