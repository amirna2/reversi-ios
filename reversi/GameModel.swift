//
//  GameModel.swift
//  reversi
//
//  Created by Amir Nathoo on 2/19/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import GameplayKit

class GameModel: NSObject, GKGameModel {
    
    // 1D array to store the game board representation
    var board = Board()
    var currentPlayer = allPlayers[0] // white player first
    
    let GKGameModelMaxScore: Int = 1000
    let GKGameModelMinScore: Int = -1000
    
    // players is required by GKGameModel protocol
    var players: [GKGameModelPlayer]? {
        return allPlayers
    }
    
    // activePlayer is required by GKGameModel protocol
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    // applyGameModelUpdate is required by GKGameModel protocol
    func applyGameModelUpdate(gameModelUpdate: GKGameModelUpdate) {
        let move = gameModelUpdate as! Move
        board[move.x,move.y] = currentPlayer.chip
        flipDiscs(move.x, move.y)
        
        //switch turn if oppenent has moves
        if Move.playerHasMoves(currentPlayer.opponent, board: self.board) {
            currentPlayer = currentPlayer.opponent
        }
    }
    
    // copyWithZone is required by NSCopying protocol
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = GameModel()
        copy.setGameModel(self)
        return copy
    }
    
    // setGameModel is required by GKGameModel protocol
    func setGameModel(gameModel: GKGameModel) {
        let sourceModel = gameModel as! GameModel
        self.board = sourceModel.board
        self.currentPlayer = sourceModel.currentPlayer
    }
    
    // gameModelUpdatesForPlayer is required by GKGameModel protocol
    func gameModelUpdatesForPlayer(player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        let player = player as! Player
        let moves: [Move] = Move.generateMovesFor(player, board: self.board)
        player.mobilityCount = moves.count
        if moves.isEmpty { return nil }
        return moves
    }
    

    func evaluation(board: Board, player: Player ) -> Int
    {
        var s1, s2: Int
        
        s1=0
        s2=0
        
        for i in 0..<8 {
            for j in 0..<8 {
                if( board[i,j] == player.opponent.chip ) {
                    s1 += boardVal[i*8+j]
                }
                else if( board[i,j] == player.chip ) {
                    s2 += boardVal[i*8+j]
                }
            }
        }
        return s2-s1;
    }//end Evaluation
    

    // scoreForPlayer is required by GKGameModel protocol
    func scoreForPlayer(player: GKGameModelPlayer) -> Int {
        let player = player as! Player
        
        var playerScore: Int
        
        // 1. start with mobility bonus
        playerScore = player.mobilityCount*3
        // 2. Static board evaluation
        playerScore += evaluation(self.board, player: player)
        // 3. Adjust for number of Discs
        playerScore += numberOfDiscs(self.board,player.chip)
        playerScore -= numberOfDiscs(self.board,player.opponent.chip)
        
        return playerScore
    }
    
    func flipDiscs(x: Int,_ y: Int) {
        let playerColor = currentPlayer.chip
        for dir in Move.dirs {
            if let move = Move.checkOneDirection(self.board, playerColor, x, y, dir)
            {   // we have find a valid move, go back and flip
                for var nextX = (move.x - dir.x),
                    nextY = (move.y - dir.y);
                    (nextX != x) || (nextY != y);
                    nextX -= dir.x, nextY -= dir.y
                {
                      self.board[nextX,nextY] = playerColor
                }
            }
        }
    }
}

