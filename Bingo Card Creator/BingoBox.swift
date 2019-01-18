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


let sampleBoxContents = [
    BoxContents(boxTitle: "Box One", boxDetails: "", proofRequired: "camera", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Two", boxDetails: "Hi Friend, I have no details", proofRequired: "signature", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Three", boxDetails: "If I had details, they would go here", proofRequired: "none", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Four", boxDetails: "", proofRequired: "signature", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Five", boxDetails: "", proofRequired: "camera", complete: false, proof: nil),
    
    BoxContents(boxTitle: "Box Six", boxDetails: "", proofRequired: "none", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Seven", boxDetails: "", proofRequired: "none", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Eight", boxDetails: "", proofRequired: "none", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Nine", boxDetails: "", proofRequired: "camera", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Ten", boxDetails: "", proofRequired: "camera", complete: false, proof: nil),
    
    BoxContents(boxTitle: "Box Eleven", boxDetails: "", proofRequired: "signature", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Twelve", boxDetails: "", proofRequired: "signature", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Thirteen", boxDetails: "", proofRequired: "signature", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Fourteen", boxDetails: "", proofRequired: "signature", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Fifteen", boxDetails: "", proofRequired: "signature", complete: false, proof: nil),
    
    BoxContents(boxTitle: "Box Sixteen", boxDetails: "", proofRequired: "camera", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Seventeen", boxDetails: "", proofRequired: "camera", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Eighteen", boxDetails: "", proofRequired: "camera", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Nineteen", boxDetails: "", proofRequired: "camera", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Twenty", boxDetails: "", proofRequired: "camera", complete: false, proof: nil),
    
    BoxContents(boxTitle: "Box Twenty-One", boxDetails: "", proofRequired: "none", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Twenty-Two", boxDetails: "", proofRequired: "none", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Twenty-Three", boxDetails: "", proofRequired: "none", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Twenty-Four", boxDetails: "", proofRequired: "none", complete: false, proof: nil),
    BoxContents(boxTitle: "Box Twenty-Five", boxDetails: "", proofRequired: "none", complete: false, proof: nil),
]


var sampleCard = BingoCard(
    title: "Sample Card",
    freeSquare: true,
    completionPoint: "Whole Card",
    contents: sampleBoxContents
)
