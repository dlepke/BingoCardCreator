//
//  ViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-08.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
    }
    
    func backgroundGradientImage(bounds:CGRect) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.5019607843, green: 0.6745098039, blue: 0.4823529412, alpha: 1).cgColor, #colorLiteral(red: 0.9101380706, green: 0.917840004, blue: 0.6302188635, alpha: 1).cgColor]
        gradientLayer.bounds = bounds
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, true, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        gradientLayer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
    
}




