//
//  CollectionViewCell.swift
//  reversi
//
//  Created by Amir Nathoo on 2/18/16.
//  Copyright © 2016 Amir Nathoo. All rights reserved.
//

import UIKit

class BoardCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
