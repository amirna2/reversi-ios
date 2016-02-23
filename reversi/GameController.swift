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
        strategist.maxLookAheadDepth = 4
    }

    /**
     Adds a chip on the GameModel board and update the board
     Parameters:
     - color: The disc color
     - row: The board row
     - col: The board column
    */
    private func addChip(color: DiscColor,_ x: Int,_ y: Int) {
        gameModel.board[x,y] = color
        
    }
    
    private func aiMove()
    {
        let delay = 1.0
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay*Double(NSEC_PER_SEC)))
       
        let mQueue = dispatch_get_main_queue()
        let cQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        //mustPass = false
        //gameView.showGameInfo("")
        dispatch_after(time, cQueue,
        {
            if (numberOfMovesLeft(self.gameModel.board) <= 20 &&
                self.getLegalMoves().count <= 7)
            {
                self.strategist.maxLookAheadDepth = 8
            }
            let move = self.strategist.bestMoveForActivePlayer() as! Move
            dispatch_async(mQueue, {
                //print("c: \(move.x),\(move.y)")
                self.makeMove(move.x, move.y)
            } )
        })
    }
    
    private func flipUIDiscs(x: Int,_ y: Int) {
        let playerColor = gameModel.currentPlayer.chip
        for dir in Move.dirs {
            if let move = Move.checkOneDirection(gameModel.board,playerColor,x,y,dir)
            {   // we have find a valid move, go back and flip
                for var nextX = (move.x - dir.x),
                        nextY = move.y - dir.y; (nextX != x) || (nextY != y); nextX -= dir.x, nextY -= dir.y {
                    gameView.updateCell(gameModel.board, x, y)
                    gameModel.board[nextX,nextY] = playerColor
                }
            }
        }
    }

    func getLegalMoves() -> [Move] {
        return Move.generateMovesFor(gameModel.currentPlayer, board: gameModel.board)
    }
    
    private func makeMove(x: Int,_ y: Int) {
        
        addChip(gameModel.currentPlayer.chip, x, y)
        flipUIDiscs(x, y)
        updateBoard()
        mustPass = false
        gameView.showGameInfo("")
        
        let white = numberOfDiscs(gameModel.board, .White)
        let black = numberOfDiscs(gameModel.board, .Black)
        
        gameModel.currentPlayer = gameModel.currentPlayer.opponent
        
        if gameIsFinished() {
            //TODO: Update UI to show who won
            var text: String
            switch (white-black) {
              case 1...64:
                text = "White Won!"
              case 0:
                text = "Draw!"
              default:
                text = "Black Won!"
            }
            gameView.showGameInfo(text)
            
            return
        }

        // shows the legal moves on the board for the current player
        let moves: [Move] = getLegalMoves()
        for i in 0..<moves.count {
            gameView.showLegalMove(gameModel.board, moves[i].x, moves[i].y)
        }
        
        if Move.playerHasMoves(gameModel.currentPlayer, board: gameModel.board ) {
            if gameModel.currentPlayer == allPlayers[0] {
                return // Wait for Human turn
            } else {
                aiMove() // AI plays
            }
        } else { // player must pass
            mustPass = true
            gameView.showGameInfo(gameModel.currentPlayer.name + " must pass!")
            
            // computer gets to play again if human player must pass
            gameModel.currentPlayer = gameModel.currentPlayer.opponent
            if gameModel.currentPlayer == allPlayers[1] {
                aiMove() // Computer to Move
            }
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
        for i in 0..<8 {
            for j in 0..<8 {
                switch (i,j) {
                case (3,3),(4,4) :
                    addChip(.White, i, j)
                case (3,4),(4,3) :
                    addChip(.Black, i, j)
                default:
                    gameModel.board[i,j] = DiscColor.None
                }
            }
        }
        gameModel.currentPlayer = allPlayers[0]
    }

    func updateBoard()
    {
        for i in 0..<8 {
            for j in 0..<8 {
                gameView.updateCell(gameModel.board, i, j)
            }
        }
        gameView.updateScore()
    }
    
    func activePlayer() -> DiscColor {
        return gameModel.currentPlayer.chip
    }
    
    func getBoardFromModel() -> Board {
        return gameModel.board
    }
    
    /**
     Called when the user taps on a board cell
     Parameters:
     - row: The board row
     - col: The board column
    */
    func processCell(x: Int, y: Int)
    {
        if(mustPass)
        {
            //mustPass = false
            //gameView.showGameInfo("")
            gameModel.currentPlayer = gameModel.currentPlayer.opponent
            if gameModel.currentPlayer == allPlayers[1] {
                aiMove() // Computer to Move
            }
            return
        }
        if Move.isLegalMove(gameModel.board,x: x, y: y, color:gameModel.currentPlayer.chip)
        {
            makeMove(x,y)
        }
    }
}















