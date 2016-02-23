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

var boardVal: [[Int]] = [
    [ 50,  4, 16, 12, 12, 16,  4, 50],
    [-30, -4, -5, -5, -4,-30,  4, -30],
    [16, -4,  1,  0,  0,  1, -4, 16],
    [2, -5,  0,  0,  0,  0, -5, 12],
    [12, -5,  0,  0,  0,  0, -5, 12],
    [16, -4,  1,  0,  0,  1, -4, 16],
    [4,-30, -4, -5, -5, -4,-30,  4],
    [50,  4, 16, 12, 12, 16,  4, 50]
]


struct Board {
    
    static var numberOfRows = 8
    static var numberOfCols = 8
    
    
    // array to store the game board representation
    private var gameBoard = [DiscColor](count: 64, repeatedValue: .None)
    
    subscript (x: Int, y: Int) -> DiscColor {
        get {
            return gameBoard[x*8 + y]
        }
        set {
            gameBoard[x*8 + y] = newValue
        }
    }    
}

let numberOfDiscs = { (board: Board, color: DiscColor) -> Int in
    var count = board.gameBoard.filter({$0 == color}).count
    return count
}










