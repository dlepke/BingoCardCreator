//
//  BingoCardInfo.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-14.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation


struct BoxContents {
    var boxTitle: String
    var boxDetails: String
    var proofRequired: Bool
}

struct BingoCard {
    var title: String
    var freeSquare: Bool
    var completionPoint: String
    var contents: [BoxContents]
}


let sampleBoxContents = [
    BoxContents(boxTitle: "Box One", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Two", boxDetails: "Hi Friend, I have no details", proofRequired: true),
    BoxContents(boxTitle: "Box Three", boxDetails: "If I had details, they would go here", proofRequired: false),
    BoxContents(boxTitle: "Box Four", boxDetails: "", proofRequired: true),
    BoxContents(boxTitle: "Box Five", boxDetails: "", proofRequired: false),
    
    BoxContents(boxTitle: "Box Six", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Seven", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Eight", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Nine", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Ten", boxDetails: "", proofRequired: false),
    
    BoxContents(boxTitle: "Box Eleven", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Twelve", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Thirteen", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Fourteen", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Fifteen", boxDetails: "", proofRequired: false),
    
    BoxContents(boxTitle: "Box Sixteen", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Seventeen", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Eighteen", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Nineteen", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Twenty", boxDetails: "", proofRequired: false),
    
    BoxContents(boxTitle: "Box Twenty-One", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Twenty-Two", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Twenty-Three", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Twenty-Four", boxDetails: "", proofRequired: false),
    BoxContents(boxTitle: "Box Twenty-Five", boxDetails: "", proofRequired: false),
]


var sampleCard = BingoCard(
    title: "Sample Card",
    freeSquare: true,
    completionPoint: "Whole Card",
    contents: sampleBoxContents
)

