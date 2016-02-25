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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func playAsBlack(sender: UIButton) {
        viewController.playerSide = DiscColor.Black
    }

    @IBAction func playAsWhite(sender: UIButton) {
        viewController.playerSide = DiscColor.White
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
