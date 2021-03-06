//
//  reversiTests.swift
//  reversiTests
//
//  Created by Amir Nathoo on 2/11/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import XCTest
@testable import reversi

class reversiTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testInitialBoardWhiteHasFourMoves() {
        let board = Board()
        
        let whiteMoves = Move.generateMovesFor(Player(chip: .White), board: board)
        XCTAssertEqual(whiteMoves.count, 4)
    }
    
    func testMustPassForAI()
    {
        let view = ViewController()
        let gameController = GameController(view: view)
        var board = gameController.getBoardFromModel()
        board[0,0] = .White
        board[1,0] = .White
        board[0,1] = .Black
        board[1,1] = .Black
        
        gameController.startPlayingAs(.Black)
        
        
    }
    
}
