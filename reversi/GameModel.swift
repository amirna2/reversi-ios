//
//  GameModel.swift
//  reversi
//
//  Created by Amir Nathoo on 2/19/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import GameplayKit

class GameModel: NSObject, GKGameModel {
    
    // array2D to store the game board representation
    var board = Board()
    var currentPlayer = allPlayers[0] // human, white
    
    
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
        board[move.row,move.col] = currentPlayer.chip
        flipCells(move.row, col: move.col)
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
        
        var moves: [Move] = []
        moves = Move.generateMovesFor(player, board: self.board)
        
        player.mobilityCount = moves.count
        if moves.isEmpty { return nil }
        return moves
    }
    
    let GKGameModelMaxScore: Int = 190
    let GKGameModelMinScore: Int = -190
    
    // scoreForPlayer is required by GKGameModel protocol
    func scoreForPlayer(player: GKGameModelPlayer) -> Int {
        let player = player as! Player
        
        var playerScore: Int
        
        // 1. start with mobility bonus
        playerScore = player.mobilityCount*3
        // 2. Static board evaluation
        playerScore = GameEngine.evaluation(self.board, player: player)
        // 3. Adjust for number of Discs
        playerScore += numberOfDiscs(self.board,player.chip)
        playerScore -= numberOfDiscs(self.board,player.opponent.chip)
        
        return playerScore
    }
    
    private func flipCells(row: Int, col: Int) {
        Move.isLegalMove(self.board, row: row, col: col, player:currentPlayer, flip: true)
    }
    
}

