//
//  OptionsViewController.swift
//  reversi
//
//  Created by Amir Nathoo on 2/24/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    var viewController: ViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAsBlack(sender: UIButton) {
        viewController.newGameAsBlack()
    }

    @IBAction func playAsWhite(sender: UIButton) {
        viewController.newGameAsWhite()
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
