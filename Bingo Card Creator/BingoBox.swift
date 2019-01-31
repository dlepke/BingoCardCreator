//
//  BingoBox.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-17.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit

class BingoBox: UICollectionViewCell {
    
    @IBOutlet weak var bingoBoxTitle: UILabel!
    
    @IBOutlet weak var bingoBoxActionIcon: UIImageView!
    
}

struct BoxContents {
    var boxTitle: String
    var boxDetails: String
    var proofRequired: String
    var complete: Bool
    var proof: UIImage?
}

struct BingoCard {
    var title: String
    var freeSquare: Bool
    var completionPoint: String
    var contents: [BoxContents]
}



