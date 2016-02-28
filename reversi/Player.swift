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

let allPlayers = [Player(chip: .White), Player(chip: .Black)]

class Player: NSObject, GKGameModelPlayer {
    private let id: Int
    
    var chip: DiscColor
    var name: String
    
    var playerId: Int {return id}
    var playerScore: Int
    // keeps track of how many moves a player can make
    // the higher the count, the better for score evaluation
    private var mobility: Int = 0
    
    var mobilityCount: Int { // counted in gameModelUpdatesForPlayer
        get {return mobility}
        set {mobility = newValue}
    }
    
    init(chip: DiscColor) {
        self.chip = chip
        self.id = chip.rawValue
        
        if chip == .White {
            name = "White"
        } else {
            name = "Black"
        }
        playerScore = 0
        super.init()
    }
    
    var opponent: Player {
        if chip == .White {
            return allPlayers[1]
        } else {
            return allPlayers[0]
        }
    }
    
    
}
