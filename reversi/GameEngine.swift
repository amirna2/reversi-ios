//
//  GameEngine.swift
//  reversi
//
//  Created by Amir Nathoo on 2/19/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import Foundation

class GameEngine {
    
    private var gameModel = GameModel()
    
    static func evaluation(board: Board, player: Player ) -> Int
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

    
}