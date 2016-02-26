//
//  OptionsViewController.swift
//  reversi
//
//  Created by Amir Nathoo on 2/24/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    
    @IBOutlet weak var playerSideControl: UISegmentedControl!
    
    @IBOutlet weak var aiLevel: UISegmentedControl!
    
    @IBOutlet weak var validMove: UISegmentedControl!
    
    var viewController: ViewController!
    
    override func viewDidLoad() {
        switch viewController.playerSide
        {
        case DiscColor.White:
            playerSideControl.selectedSegmentIndex = 0
        case DiscColor.Black:
            playerSideControl.selectedSegmentIndex = 1
        default:
            break;
        }
        
        switch viewController.aiLevel
        {
        case GameLevel.Easy:
            aiLevel.selectedSegmentIndex = 0
        case GameLevel.Medium:
            aiLevel.selectedSegmentIndex = 1
        case GameLevel.Hard:
            aiLevel.selectedSegmentIndex = 2
            
        default:
            break;
        }
        
        switch viewController.showMoves
        {
        case true:
            validMove.selectedSegmentIndex = 0
        case false:
            validMove.selectedSegmentIndex = 1
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectAiLevel(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            viewController.aiLevel = GameLevel.Easy
        case 1:
            viewController.aiLevel = GameLevel.Medium
        case 2:
            viewController.aiLevel = GameLevel.Hard
        default:
            break;
        }
    }
    @IBAction func selectPlayerSide(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            viewController.playerSide = DiscColor.White
        case 1:
            viewController.playerSide = DiscColor.Black
        default:
            break; 
        }
    }
    
    @IBAction func showValidMoves(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            viewController.showMoves = true
        case 1:
            viewController.showMoves = false
        default:
            break;
        }

    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
