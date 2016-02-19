//
//  Move.swift
//  reversi
//
//  Created by Amir Nathoo on 2/11/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import Foundation
import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    var row: Int
    
    init(row: Int, column: Int) {
        self.column = column
        self.row = row
    }
    
    func checkLegalMove(board: Board, row: Int, col:Int, player:Player, opponent:Player, flip:Bool) -> Bool
    {
        var legal: Bool = false
        var stepCount: Int = 0
        
        if(board.position[row][col] == DiscColor.None)
        {
            var xdir,ydir,i,j: Int
            for(xdir = -1; xdir < 2; xdir++)
            {
                for (ydir = -1; ydir < 2; ydir++)
                {
                    stepCount = 0
                    repeat
                    {
                        stepCount++;
                        i = row + stepCount*xdir; // so many steps along x-axis
                        j = col + stepCount*ydir; // so many steps along y-axis
                    }
                    while ( (i > 0) && (i < 9) && (j > 0) && (j < 9) && (board.position[i][j] == opponent.chip));
                    if (( i > 0) && (i < 9) && (j > 0) && (j < 9) && (stepCount > 1) && (board.position[i][j] == player.chip) )
                    {
                        legal = true;
                        // Should we create a new board ?
                        if (flip)
                        {
                            var k: Int
                            for (k = 1; k < stepCount; k++)
                            {
                                board.position[row+xdir*k][col+ydir*k] = player.chip;
                            }
                            board.position[row][col] = player.chip;
                        }
                    }
                }
            }
        }
        return legal
    }
}