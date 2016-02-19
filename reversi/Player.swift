//
//  Player.swift
//  reversi
//
//  Created by Amir Nathoo on 2/11/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import Foundation

import GameplayKit
import UIKit

class Player: NSObject, GKGameModelPlayer {
    var chip: DiscColor
    var color: UIColor
    var name: String
    var playerId: Int
    
    static var allPlayers = [Player(chip: .White), Player(chip: .Black)]
    
    init(chip: DiscColor) {
        self.chip = chip
        self.playerId = chip.rawValue
        
        if chip == .White {
            color = .whiteColor()
            name = "White"
        } else {
            color = .blackColor()
            name = "Black"
        }
        
        super.init()
    }
    
    var opponent: Player {
        if chip == .White {
            return Player.allPlayers[1]
        } else {
            return Player.allPlayers[0]
        }
    }
}
