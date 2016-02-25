//
//  GameEngine.swift
//  reversi
//
//  Created by Amir Nathoo on 2/19/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import GameplayKit
import UIKit

struct GameLevel {
    static let Easy = 0
    static let Medium = 1
    static let Hard = 2
}

struct GameStage {
    static let Openning = 0
    static let Middle = 1
    static let End = 2
}

class GameController {
    

    private var gameModel = GameModel()
    private let strategist = GKMinmaxStrategist()
    
    private var gameView: ViewController

    private var aiCurrentLevel = GameLevel.Easy
    
    private var aiLevels = [ [1,2,1], // Easy level : LookAheadDepth values for openning, middle and end game
                             [3,4,5], // Medium
                             [4,5,6]  // Hard
                           ]
    private var showMoves = true
    private var playerSide = DiscColor.White
    
    init(view: ViewController) {
        self.gameView = view
        strategist.gameModel = gameModel
        strategist.maxLookAheadDepth = aiLevels[aiCurrentLevel][GameStage.Openning]
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
        dispatch_after(time, cQueue,
        {
            switch numberOfEmptySquares(self.gameModel.board) {
                case 45...60: //openning game
                    self.strategist.maxLookAheadDepth = self.aiLevels[self.aiCurrentLevel][GameStage.Openning]
                case 20...44: //middle game
                    self.strategist.maxLookAheadDepth = self.aiLevels[self.aiCurrentLevel][GameStage.Middle]
                case 0...19:
                    self.strategist.maxLookAheadDepth = self.aiLevels[self.aiCurrentLevel][GameStage.End]
                default:
                    break;
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

    func getLegalMoves(player: Player) -> [Move] {
        return Move.generateMovesFor(player, board: gameModel.board)
    }
    
    private func makeMove(x: Int,_ y: Int) {
        
        addChip(gameModel.currentPlayer.chip, x, y)
        flipUIDiscs(x, y)
        updateBoard()
        gameView.showGameInfo(-1)
        
        let white = numberOfDiscs(gameModel.board, .White)
        let black = numberOfDiscs(gameModel.board, .Black)
        
        gameModel.currentPlayer = gameModel.currentPlayer.opponent
        
        if gameIsFinished() {
            //TODO: Update UI to show who won
            var gameState: Int
            switch (white-black) {
              case 1...64:
                gameState = 1 // White Won
              case 0:
                gameState = 0 // Draw
              default:
                gameState = 2 // Black Won
            }
            gameView.showGameInfo(gameState)
            
            return
        }

        // shows the legal moves on the board for the current player
        let moves: [Move] = getLegalMoves(gameModel.currentPlayer)
        for i in 0..<moves.count {
            gameView.showLegalMove(gameModel.board, moves[i].x, moves[i].y)
        }
        
        //if Move.playerHasMoves(gameModel.currentPlayer, board: gameModel.board ) {
        if (moves.count > 0) {
            if gameModel.currentPlayer.name == "HUMAN" {
                return // Wait for Human turn
            } else {
                aiMove() // AI plays
            }
        } else { // player must pass
            gameView.showGameInfo(3)
            
            // computer gets to play again if human player must pass
            // if computer must pass, this will cause processCell to be called when human player makes a move
            gameModel.currentPlayer = gameModel.currentPlayer.opponent
            if gameModel.currentPlayer.name == "AI" {
                aiMove() // Computer to Move
            }
            else // show moves for human player
            {
                let moves: [Move] = getLegalMoves(gameModel.currentPlayer)
                for i in 0..<moves.count {
                    gameView.showLegalMove(gameModel.board, moves[i].x, moves[i].y)
                }
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
    

    func setTestBoard() {
        for i in 0..<8 {
            for j in 0..<8 {
                switch (i,j) {
                case (0,0),(1,0) :
                    addChip(.White, i, j)
                case (0,1),(1,1) :
                    addChip(.Black, i, j)
                default:
                    gameModel.board[i,j] = DiscColor.None
                }
            }
        }
        gameModel.currentPlayer = allPlayers[0]
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
    
    func activePlayer() -> String {
        return gameModel.currentPlayer.name
    }
    func activePlayerColor() -> DiscColor {
        return gameModel.currentPlayer.chip
    }
    func startNewGame(playerSide: DiscColor,_ level: Int,_ showMoves: Bool)
    {
        self.playerSide = playerSide
        self.aiCurrentLevel = level
        self.showMoves = showMoves
        
        // shows the legal moves on the board for the current player
        let moves: [Move] = getLegalMoves(gameModel.currentPlayer)
        for i in 0..<moves.count {
            gameView.showLegalMove(gameModel.board, moves[i].x, moves[i].y)
        }

        // Let computer play first as white
        // If player wants to play first, just wait for a tap on a board cell
        if(playerSide == .Black)
        {
            gameModel.currentPlayer.name = "AI"
            gameModel.currentPlayer.opponent.name = "HUMAN"
            aiMove()

        }
        else
        {
            gameModel.currentPlayer.name = "HUMAN"
            gameModel.currentPlayer.opponent.name = "AI"
            
        }
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

        if Move.isLegalMove(gameModel.board,x: x, y: y, color:gameModel.currentPlayer.chip)
        {
            makeMove(x,y)
        }
    }
}















