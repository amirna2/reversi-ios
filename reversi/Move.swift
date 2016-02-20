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
    
    
    private var score: Int = 0
    // required by GKGameModelUpdate protocol
    var value: Int {
        get { return score }
        set { score = newValue }
    }
    // constants to save move position
    let row: Int
    let col: Int
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        super.init()
    }
    
    static func playerHasMoves(player: Player, board: Board) -> Bool
    {
        for r in 0..<8 {
            for c in 0..<8 {
                if isLegalMove(board, row: r, col: c, player: player, flip: false)
                {
                    return true
                }
            }
        }
        return false
    }
    
    static func generateMovesFor(player: Player, board: Board) -> [Move]
    {
        var moves: [Move] = []
        for r in 0..<8 {
            for c in 0..<8 {
                if isLegalMove(board, row: r, col: c, player: player, flip: false)
                {
                    moves.append(Move(row:r, col:c))
                }
            }
        }
        return moves
    }
    
    static func isLegalMove(var board: Board, row: Int, col: Int, player:Player, flip: Bool) -> Bool
    {
        var legal: Bool = false
        var i,j,stepCount: Int
        
        let opponentChip: DiscColor = (player.chip == .White) ? .Black : .White

        if (board.gameBoard[row][col] == DiscColor.None)
        {
            return legal
        }
        
        for xdir in -1..<2 {
            for ydir in -1..<2 {
                stepCount = 0
                repeat
                {
                    stepCount++;
                    i = row + stepCount*xdir; // so many steps along x-axis
                    j = col + stepCount*ydir; // so many steps along y-axis
                }
                while ( (i > 0) && (i < 8) && (j > 0) && (j < 8) && (board.gameBoard[i][j] == opponentChip));
                
                if (( i > 0) && (i < 8) && (j > 0) && (j < 8) && (stepCount > 1) && (board.gameBoard[i][j] == player.chip) )
                {
                    legal = true;
                    if (flip)
                    {
                        for k in 1..<stepCount
                        {
                            board.gameBoard[row+xdir*k][col+ydir*k] = player.chip;
                        }
                        board.gameBoard[row][col]=player.chip;
                    }
                }
            }
        }
        return legal
    }
    
}