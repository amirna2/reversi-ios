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
    @IBOutlet weak var gameInfo: UILabel!
   
    
    var board: Board!
    var player: Player!
    var gameController: GameController!
    var playerSide = DiscColor.White
    var aiLevel = GameLevel.Easy
    var showMoves = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        boardView.delegate = self
        boardView.dataSource = self
        
        gameInfo.text = ""
    
        board = Board()
        player = Player(chip: playerSide)
        gameController = GameController(view: self)
        gameController.setInitialBoard()
        //gameController.setTestBoard()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "GameOptions")
        {
            let OptionsVC:OptionsViewController = segue.destinationViewController as! OptionsViewController
            let data = sender as! ViewController
            OptionsVC.viewController = data
        }
    }
    
    
    @IBAction func setupGame(sender: UIButton) {
        self.performSegueWithIdentifier("GameOptions", sender: self)
    }
    
    
    
    @IBAction func startNewGame(sender: UIButton) {
        gameController.startNewGame(playerSide, aiLevel, showMoves)
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
        if( gameController.getBoardFromModel()[indexPath.row,indexPath.section] == DiscColor.Black)
        {
            cell.cellImage.image = UIImage(named: "BlackPiece")
        }
        else if( gameController.getBoardFromModel()[indexPath.row,indexPath.section] == DiscColor.White)
        {
           cell.cellImage.image = UIImage(named: "WhitePiece")
        }
        return cell
    }
    
    func showGameInfo(state: Int)
    {
        switch state {
        case 0:
            gameInfo.text = "Draw!"
        case 1:
            gameInfo.text = "White Won!"
        case 2:
            gameInfo.text = "Black Won!"
        case 3:
            if(gameController.activePlayerColor() == .White) {
                gameInfo.text = "White must pass!"
            } else {
                gameInfo.text = "Black must pass!"
            }
        default:
            gameInfo.text = ""
        }
    }
    
    func showLegalMove(board: Board,_ x: Int,_ y: Int)
    {
        let indexPath = NSIndexPath(forRow: x, inSection: y)
        
        let cell = boardView.cellForItemAtIndexPath(indexPath) as! BoardCell
        if(gameController.activePlayerColor() == .White) {
            cell.cellLabel.textColor = UIColor.whiteColor()
        }
        else {
            cell.cellLabel.textColor = UIColor.grayColor()
        }
        cell.cellLabel.text = "●"
    }
    
    func updateScore()
    {
        whiteScore.text = String(numberOfDiscs(gameController.getBoardFromModel(), .White))
        blackScore.text = String(numberOfDiscs(gameController.getBoardFromModel(), .Black))
    }
    func updateCell(board: Board,_ x: Int,_ y: Int)
    {
        let indexPath = NSIndexPath(forRow: x, inSection: y)
        
        let cell = boardView.cellForItemAtIndexPath(indexPath) as! BoardCell
        if(board[x,y] == .White)
        {
            cell.cellImage.image = UIImage(named: "WhitePiece")
        }
        if(board[x,y] == .Black)
        {
            cell.cellImage.image = UIImage(named: "BlackPiece")
        }
        
        if(board[x,y] == .Legal)
        {
            if(gameController.activePlayerColor() == .White) {
                cell.cellLabel.textColor = UIColor.whiteColor()
            }
            else {
                cell.cellLabel.textColor = UIColor.grayColor()
            }
            cell.cellLabel.text = "●"
        }
        else
        {
            cell.cellLabel.text = ""
        }
    }
    // detects and processes taps in a given cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(gameController.activePlayer() == "HUMAN")
        {
            //print("p: \(indexPath.row),\(indexPath.section)")
            gameController.processCell(indexPath.row, y:indexPath.section)
        }
    }
    
    
}

