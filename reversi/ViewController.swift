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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       boardView.delegate = self
        boardView.dataSource = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 1
        // Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("square", forIndexPath: indexPath) as! BoardCell
        return cell
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            
            let position = touch.locationInView(view)
            
            let indexPath = NSIndexPath(forRow: Int(position.x), inSection: Int(position.y))
            let cell: UICollectionViewCell!
            print(position)
            cell = boardView.cellForItemAtIndexPath(indexPath)
            if(cell != nil)
            {
                print(cell.layer.position)
            }
            else
            {
                print("Out of Bounds!")
            }
        }
    }
    
    
}

