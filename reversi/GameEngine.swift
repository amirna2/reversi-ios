//
//  GameEngine.swift
//  reversi
//
//  Created by Amir Nathoo on 2/19/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import GameplayKit

class GameEngine {
    
    private var gameModel = GameModel()
    
    /**
     Populate adds a chip on the GameModel board
     Parameters:
     - color: The disc color
     - row: The board row
     - col: The board column
    */
    private func addChip(color: DiscColor, row: Int, column: Int) {
        gameModel.board[row,column] = color
    }
    
    private func aiMove()
    {
        let strategist = GKMinmaxStrategist()
        strategist.gameModel = gameModel
        strategist.maxLookAheadDepth = 6
        let delay = 1.0
        let time = dispatch_time(DISPATCH_TIME_NOW,
            Int64(delay*Double(NSEC_PER_SEC)))
       
        let mQueue = dispatch_get_main_queue()
        let cQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        dispatch_after(time, cQueue,
        {
            let move = strategist.bestMoveForActivePlayer() as! Move
            dispatch_async(mQueue, { self.makeMove(move.row, move.col) } )
        })
    }
    
    private func makeMove(row: Int,_ col: Int) {
        addChip(gameModel.currentPlayer.chip, row: row, column: col)
        gameModel.flipCells(row, col)
        //let white = numberOfDiscs(gameModel.board, .White)
        //let black = numberOfDiscs(gameModel.board, .Black)
        
        gameModel.currentPlayer = gameModel.currentPlayer.opponent
        
        if gameIsFinished() {
            return
        }
        
        if Move.playerHasMoves(gameModel.currentPlayer, board: gameModel.board ) {
            if gameModel.currentPlayer == allPlayers[0] {
                return // wait for human move
            } else {
                aiMove() // let AI work
            }
        } else { // player must pass
            
            // TODO
        }
    }
    
    
    func gameIsFinished() -> Bool {
        if Move.playerHasMoves(gameModel.currentPlayer,board: gameModel.board) ||
            Move.playerHasMoves(gameModel.currentPlayer.opponent, board: gameModel.board )
        {
            return false
        }
        return true
    }
    
    func play(row: Int,_ col: Int)
    {
        if gameIsFinished()
        {
            return
        }
        
        gameModel.currentPlayer = gameModel.currentPlayer.opponent
        
        if gameModel.currentPlayer == allPlayers[1]
        {
            aiMove() // let AI work
        }
        else
        {
            if Move.isLegalMove(gameModel.board, row: row, col: col, player:gameModel.currentPlayer, flip: false)
            {
                makeMove(row,col)
            }
        }
        
    }
}















