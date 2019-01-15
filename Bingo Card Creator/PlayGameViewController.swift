//
//  PlayGameViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-09.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit

class PlayGameViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        for button in BingoCardButtons {
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            button.titleLabel?.textAlignment = .center
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 1
            
        }
        
    }
    
    
    
    @IBAction func bingoClick(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.3529411765, blue: 0.337254902, alpha: 0.5)
        print(sender.currentTitle!)
    }
    
    
    @IBOutlet var BingoCardButtons: [UIButton]!
}
