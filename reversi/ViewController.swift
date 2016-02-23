//
//  ViewController.swift
//  reversi
//
//  Created by Amir Nathoo on 2/11/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var boardView: UICollectionView!
    @IBOutlet weak var blackScore: UILabel!
    @IBOutlet weak var whiteScore: UILabel!
    
    var board: Board!
    var player: Player!
    var whiteChip = DiscColor.White
    var gameController: GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        boardView.delegate = self
        boardView.dataSource = self
        board = Board()
        player = Player(chip: whiteChip)
        gameController = GameController(view: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Returns the number of sections
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 8
    }
    
    // Returns the number of items in a section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    
    // Populates the collection with cells based on the square cell template
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("square", forIndexPath: indexPath) as! BoardCell

        gameController.setInitialBoard()
        
        if( board.gameBoard[indexPath.row][indexPath.section] == DiscColor.Black)
        {
            cell.cellImage.image = UIImage(named: "BlackPiece")
        }
        else if( board.gameBoard[indexPath.row][indexPath.section] == DiscColor.White)
        {
           cell.cellImage.image = UIImage(named: "WhitePiece")
        }
        
        return cell
    }
    
    func showLegalMove(board: Board,_ x: Int,_ y: Int)
    {
        let indexPath = NSIndexPath(forRow: x, inSection: y)
        
        let cell = boardView.cellForItemAtIndexPath(indexPath) as! BoardCell
        cell.cellLabel.text = "⚬"
    }
    
    func updateScore(player: Player)
    {
        if(player.chip == .White) {
            whiteScore.text = String(player.score)
            blackScore.text = String(player.opponent.score)
        }
        else {
            blackScore.text = String(player.score)
            whiteScore.text = String(player.opponent.score)
        }
    }
    func updateCell(board: Board,_ x: Int,_ y: Int)
    {
        let indexPath = NSIndexPath(forRow: x, inSection: y)
        
        let cell = boardView.cellForItemAtIndexPath(indexPath) as! BoardCell
        if(board.gameBoard[x][y] == .White)
        {
            cell.cellImage.image = UIImage(named: "WhitePiece")
        }
        if(board.gameBoard[x][y] == .Black)
        {
            cell.cellImage.image = UIImage(named: "BlackPiece")
        }
        
        if(board.gameBoard[x][y] == .Legal)
        {
            cell.cellLabel.text = "o"
        }
        else
        {
            cell.cellLabel.text = ""
        }
    }
    // detects and processes taps in a given cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(gameController.activePlayer() == .White)
        {
            print("p: \(indexPath.row),\(indexPath.section)")
            gameController.processCell(indexPath.row, y:indexPath.section)
        }
    }
    
    
}

