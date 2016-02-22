//
//  Move.swift
//  reversi
//
//  Created by Amir Nathoo on 2/11/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import Foundation
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    
    
    // offsets for looking up discs in all directions
    static let dirs: [(x: Int,y: Int)] =
    [ ( 1,-1), ( 1,0), ( 1,1),  // up-left, up, up-right
      ( 0,-1),         ( 0,1),  // left, ,right
      (-1,-1), (-1,0), (-1,1)   // down-left, down, down-right
    ]

    private var score: Int = 0
    // required by GKGameModelUpdate protocol
    var value: Int {
        get { return score }
        set { score = newValue }
    }
    // constants to save move position
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        super.init()
    }
    override var description: String {
        get { return "Move(\(x),\(y))" }
    }
    
    static func checkOneDirection(board: Board,_ color: DiscColor,_ x: Int,_ y: Int, _ dir: (x: Int,y: Int) ) -> Move? {
            
        // to check out of bounds
        let outOfBounds = {return ($0<0) || ($0>7)}
        let opponentColor: DiscColor = (color == .White) ? .Black : .White
        
        var Xn = x + dir.x
        if outOfBounds(Xn) {
            return nil
        }
        var Yn = y + dir.y
        if outOfBounds(Yn) {
            return nil
        }
        if board[Xn,Yn] != opponentColor  { //empty or same color
            return nil
        }
        // move in one direction
        while board[Xn,Yn] == opponentColor {
            Xn += dir.x
            if outOfBounds(Xn) {
                return nil
            }
            Yn += dir.y
            if outOfBounds(Yn) {
                return nil
            }
        }
        if board[Xn,Yn] == color // we have found a possible move
        {
            return Move(x: Xn, y: Yn)
        }
        
        return nil
    }

    /**
     Checks if a move is valid. Returns true if it s, false otherwise.
     Also sets the board cell state to ".Legal" if the move is valid
     Parameters
     - board: an instance of Board
     - x: the x coordinate of the move
     - y: the y coordinate of the move
     - color: the cell state to check for
    */
    static func isLegalMove(board: Board, x: Int, y: Int, color: DiscColor) -> Bool {
        if (board[x,y] == .White || board[x,y] == .Black) {
            return false
        }
        for dir in dirs {
            if self.checkOneDirection(board, color, x, y, dir) != nil {
                return true
            }
        }
        return false // not valid move
    }

    static func playerHasMoves(player: Player, board: Board) -> Bool {
        for i in 0..<8 {
            for j in 0..<8 {
                if isLegalMove(board, x: i, y: j, color: player.chip)
                {
                    return true
                }
            }
        }
        return false
    }
    
    static func generateMovesFor(player: Player, var board: Board) -> [Move] {
        var moves: [Move] = []
        for i in 0..<8 {
            for j in 0..<8 {
                if isLegalMove(board, x: i, y: j, color: player.chip)
                {
                    moves.append(Move(x: i, y: j))
                    board[i,j] = .Legal
                }
            }
        }
        return moves
    }
    

}