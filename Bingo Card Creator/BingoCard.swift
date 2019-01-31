//
//  BingoCard.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-30.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit


struct BingoCard {
    var title: String
    var freeSquare: Bool
    var completionPoint: String
    var contents: [BoxContents]
}

struct BoxContents {
    var boxTitle: String
    var boxDetails: String
    var proofRequired: String
    var complete: Bool
    var proof: UIImage?
}
