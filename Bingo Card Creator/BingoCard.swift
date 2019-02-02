//
//  BingoCard.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-30.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit
import os.log

struct BoxContents {
    var boxTitle: String
    var boxDetails: String
    var proofRequired: String
    var complete: Bool
    var proof: UIImage?
}

struct BingoCard {
    var title: String = ""
    var freeSquare: Bool = true
    var completionPoint: String = ""
    var contents: [BoxContents] = []
}
