//
//  Board.swift
//  reversi
//
//  Created by Amir Nathoo on 2/11/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import GameplayKit
import UIKit

enum DiscColor: Int {
    case None = 0
    case White
    case Black
    case Legal
}

class Board: NSObject, GKGameModel {
    static var width = 8
    static var height = 8
    
    var position: [[DiscColor]] = [
        [ .None, .None, .None, .None, .None, .None, .None, .None ],
        [ .None, .None, .None, .None, .None, .None, .None, .None ],
        [ .None, .None, .None, .None, .None, .None, .None, .None ],
        [ .None, .None, .None, .White, .Black, .None, .None, .None ],
        
        [ .None, .None, .None, .Black, .White, .None, .None, .None ],
        [ .None, .None, .None, .None, .None, .None, .None, .None ],
        [ .None, .None, .None, .None, .None, .None, .None, .None ],
        [ .None, .None, .None, .None, .None, .None, .None, .None ]
    ]
    var currentPlayer: Player
    
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    override init() {
        currentPlayer = Player.allPlayers[0]        
        super.init()
    }
    
    func discOnBoard(column: Int, row: Int) -> DiscColor {
        return position[row][column]
    }
    
    func placeDisc(disc: DiscColor, inColumn column: NSInteger, row: NSInteger) {
        position[row][column] = disc;
    }
    
    
    func isWinForPlayer(player: GKGameModelPlayer) -> Bool {
        return false
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }
    
    func setGameModel(gameModel: GKGameModel) {
        if let board = gameModel as? Board {
            position = board.position
            currentPlayer = board.currentPlayer
        }
    }
    
    
    func gameModelUpdatesForPlayer(player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        // 1
        if let playerObject = player as? Player {
            // 2
            if isWinForPlayer(playerObject) || isWinForPlayer(playerObject.opponent) {
                return nil
            }
            
            // 3
            let moves = [Move]()
            
            // 4 - [an] Move generator
            // if some valid move, add to moves list
            
            //for column in 0 ..< Board.width {
                //if canMoveInColumn(column) {
                //    // 5
                //    moves.append(Move(column: column))
                //}
            //}
            
            // 6
            return moves;
        }
        
        return nil
    }
    
    func applyGameModelUpdate(gameModelUpdate: GKGameModelUpdate) {
        if let move = gameModelUpdate as? Move {
            placeDisc(currentPlayer.chip, inColumn: move.column, row: move.row)
            currentPlayer = currentPlayer.opponent
        }
    }
    
    func scoreForPlayer(player: GKGameModelPlayer) -> Int {
        if let playerObject = player as? Player {
            if isWinForPlayer(playerObject) {
                return 1000
            } else if isWinForPlayer(playerObject.opponent) {
                return -1000
            }
        }
        
        return 0
    }
}
