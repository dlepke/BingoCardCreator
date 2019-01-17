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
        
        popUpView.layer.cornerRadius = 5
        
        for button in BingoCardButtons {
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            button.titleLabel?.textAlignment = .center
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 1
            
        }
        
    }
    
    // today, working on logic to parse and display a user-made bingo card (using sample data)
    
    // first, receive card info
    
    // second, apply card title to nav bar
    
    // third, apply free square if free square
    
    // fourth, populate (shuffled?) bingo boxes text
    
    // fifth, apply proof requirements to each box according to setting & fill popup menu
    

    
    
    
    
    
    
    
    
    @IBAction func bingoClick(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.3529411765, blue: 0.337254902, alpha: 0.5)
        print(sender.currentTitle!)
        
        // here goes the popup menu
        animateIn(senderButton: sender)
    }
    
    
    @IBOutlet var BingoCardButtons: [UIButton]!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var popUpView: UIView!
    
    func animateIn(senderButton: UIButton) {
        self.view.addSubview(popUpView)
        
        print("animating in")
        
        
        let popUpViewWidth = popUpView.frame.maxX - popUpView.frame.minX
        let popUpViewHeight = popUpView.frame.maxY - popUpView.frame.minY
        
        print(mainView.frame.maxY)
        print(senderButton.center)
        
        
        if popUpViewWidth > mainView.frame.maxX - senderButton.frame.midX
            && popUpViewHeight > mainView.frame.maxY - senderButton.frame.midY {
            //for bottom right corner
            popUpView.frame.origin.x = senderButton.center.x - popUpViewWidth
            popUpView.frame.origin.y = senderButton.center.y - popUpViewHeight
            
            
            print("bottom right corner")
            
            
            
            
            
        } else if popUpViewHeight > mainView.frame.maxY - senderButton.frame.midY {
        //for bottom row
                popUpView.frame.origin.x = senderButton.center.x
                popUpView.frame.origin.y = senderButton.center.y - popUpViewHeight
            
            
            print("bottom row")
            
            
            
            
            
        } else if popUpViewWidth > mainView.frame.maxX - senderButton.frame.midX {
        //for rightmost column
                popUpView.frame.origin.x = senderButton.center.x - popUpViewWidth
                popUpView.frame.origin.y = senderButton.center.y
            
            
            print("rightmost column")
    
            
            
            
            
        } else {
            popUpView.frame.origin.x = senderButton.center.x
            popUpView.frame.origin.y = senderButton.center.y
            
            
            print("one!")
        }
        
        
        
        
        
        
        
        
        
        
        
        
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        
        
        UIView.animate(withDuration: 0.4) {
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
        
    }
    
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popUpView.alpha = 0
            
        }) { (success:Bool) in
            self.popUpView.removeFromSuperview()
        }
    }
}
