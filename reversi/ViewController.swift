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
    
    var board: Board!
    var player: Player!
    var whiteChip = DiscColor.White
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        boardView.delegate = self
        boardView.dataSource = self
        board = Board()
        player = Player(chip: whiteChip)
        
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
    
    // detects and processes taps in a given cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BoardCell
        
        var isLegal: Bool = false
        
        isLegal = Move.isLegalMove(board, row: indexPath.row, col: indexPath.section, player: player, flip: false)
        if( isLegal )
        {
            if( player.name == "White") {
               cell.cellImage.image = UIImage(named: "WhitePiece")
            }
            else {
               cell.cellImage.image = UIImage(named: "BlackPiece")
            }
        }
        
    }
    
    
}

