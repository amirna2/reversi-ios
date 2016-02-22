//
//  GameEngine.swift
//  reversi
//
//  Created by Amir Nathoo on 2/19/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import GameplayKit
import UIKit

class GameController {
    
    private var gameModel = GameModel()
    private let strategist = GKMinmaxStrategist()
    
    private var gameView: ViewController
    private var mustPass = false
    
    init(view: ViewController) {
        self.gameView = view
        strategist.gameModel = gameModel
        strategist.maxLookAheadDepth = 6
    }

    /**
     Adds a chip on the GameModel board and update the board
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
        let delay = 1.0
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay*Double(NSEC_PER_SEC)))
       
        let mQueue = dispatch_get_main_queue()
        let cQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        dispatch_after(time, cQueue,
        {
            let move = self.strategist.bestMoveForActivePlayer() as! Move
            dispatch_async(mQueue, { self.makeMove(move.row, move.col) } )
        })
    }
    
    private func makeMove(row: Int,_ col: Int) {
        
        
        addChip(gameModel.currentPlayer.chip, row: row, column: col)
        updateBoard()
        
        let white = numberOfDiscs(gameModel.board, .White)
        let black = numberOfDiscs(gameModel.board, .Black)
        
        gameModel.currentPlayer = gameModel.currentPlayer.opponent
        
        if gameIsFinished() {
            return
        }
        
        print(white, black)
        
        if Move.playerHasMoves(gameModel.currentPlayer, board: gameModel.board ) {
            if gameModel.currentPlayer == allPlayers[0] {
                return // wait for human move
            } else {
                aiMove() // let AI work
            }
        } else { // player must pass
            
            mustPass = true
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
    
    
    func setInitialBoard() {
        for row in 0..<8 {
            for col in 0..<8 {
                switch (row,col) {
                case (3,3),(4,4) :
                    addChip(.White, row: row, column: col)
                case (3,4),(4,3) :
                    addChip(.Black, row: row, column: col)
                default:
                    gameModel.board.gameBoard[row][col] = DiscColor.None
                }
            }
        }
        gameModel.currentPlayer = allPlayers[0]
    }

    
    func updateBoard()
    {
        for row in 0..<8 {
            for col in 0..<8 {
                gameView.updateCell(gameModel.board, row, col)
            }
        }
    }
    
    
    /**
     Called when the user taps on a board cell
     Parameters:
     - row: The board row
     - col: The board column
    */
    func processCell(row: Int,_ col: Int)
    {
        if(mustPass)
        {
            gameModel.currentPlayer = gameModel.currentPlayer.opponent
            if gameModel.currentPlayer == allPlayers[1] {
                aiMove() // Computer to Move
            }
            return
        }
        if Move.isLegalMove(gameModel.board, row: row, col: col, player:gameModel.currentPlayer, flip: true)
        {
            makeMove(row,col)
        }
    }
}















