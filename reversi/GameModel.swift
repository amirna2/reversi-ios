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
    
    let GKGameModelMaxScore: Int = 190
    let GKGameModelMinScore: Int = -190
    
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
        board.gameBoard[move.row][move.col] = currentPlayer.chip
        flipCells(move.row, move.col)
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
    

    
    func evaluation(board: Board, player: Player ) -> Int
    {
        var s1, s2, i, j: Int
        
        s1=0
        s2=0
        
        for( i=0; i < 8; i++ )
        {
            for( j=0; j < 8; j++)
            {
                if( board.gameBoard[i][j] == player.opponent.chip ) {
                    s1 += boardVal[i][j]
                }
                else if( board.gameBoard[i][j] == player.chip ) {
                    s2 += boardVal[i][j]
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
    
    func flipCells(row: Int,_ col: Int) {
        Move.isLegalMove(self.board, row: row, col: col, player:currentPlayer, flip: true)
    }
    
}

