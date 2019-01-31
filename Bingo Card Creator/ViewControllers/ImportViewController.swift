//
//  ImportViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-09.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}


class ImportViewController: UIViewController {
    
    @IBOutlet weak var SelectFileButton: UIButton!
    @IBOutlet weak var SelectedFileTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        SelectFileButton.layer.cornerRadius = 10
        SelectFileButton.layer.applySketchShadow()
        
        // this is just adding padding to ends of textfield
        let paddingView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: self.SelectedFileTextField.frame.height)))
        SelectedFileTextField.leftView = paddingView
        SelectedFileTextField.leftViewMode = UITextField.ViewMode.always
        // end padding section
        SelectedFileTextField.layer.applySketchShadow()
    }
}
