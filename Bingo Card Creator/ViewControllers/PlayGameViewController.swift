//
//  PlayGameViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-09.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit

class PlayGameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var bingoCardCollectionView: UICollectionView!
    @IBOutlet weak var bingoCardFlow: UICollectionViewFlowLayout!
    
    var currentBingoCard: BingoCard?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentBingoCard?.title
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        bingoCardCollectionView.dataSource = self
        bingoCardCollectionView.delegate = self
        
        bingoCardFlow.minimumLineSpacing = 0
        bingoCardFlow.minimumInteritemSpacing = 0
        bingoCardFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let totalWidth = view.frame.width
        
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        let bottomPadding = window?.safeAreaInsets.bottom
        let totalHeight = view.frame.height - topPadding! - bottomPadding! - (self.navigationController?.navigationBar.frame.height)!
        let sizeOfGrid = 5
        let widthOfCell = CGFloat(Int(totalWidth) / sizeOfGrid)
        let heightOfCell = CGFloat(Int(totalHeight) / sizeOfGrid)
        bingoCardFlow.itemSize = CGSize(width: widthOfCell, height: heightOfCell)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = bingoCardCollectionView.cellForItem(at: indexPath) as! BingoBox
        let selectedBingoBox = currentBingoCard?.contents[indexPath.row]
        
        if selectedBingoBox?.complete == true {
            selectedCell.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.3529411765, blue: 0.337254902, alpha: 1)
            currentBingoCard?.contents[indexPath.row].complete = false
        } else {
            selectedCell.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.6745098039, blue: 0.4823529412, alpha: 0.2504548373)
            currentBingoCard?.contents[indexPath.row].complete = true
        }
        print(currentBingoCard?.contents[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cellToDeselect = bingoCardCollectionView.cellForItem(at: indexPath) as! BingoBox
        let deselectedBingoBox = currentBingoCard?.contents[indexPath.row]
        
        if deselectedBingoBox?.complete != true {
            cellToDeselect.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.3529411765, blue: 0.337254902, alpha: 1)
        }

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentBingoCard?.contents.count ?? 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentBingoBox = currentBingoCard?.contents[indexPath.row]
        
        let cell = bingoCardCollectionView.dequeueReusableCell(withReuseIdentifier: "BingoBox", for: indexPath as IndexPath) as! BingoBox
        let cellColor = #colorLiteral(red: 0.3764705882, green: 0.3529411765, blue: 0.337254902, alpha: 1)
        cell.backgroundColor = cellColor
        cell.bingoBoxTitle.text = currentBingoBox?.boxTitle
        cell.bingoBoxTitle.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.bingoBoxTitle.textAlignment = .center
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        if currentBingoBox?.proofRequired == "camera" {
            cell.bingoBoxActionIcon.image = #imageLiteral(resourceName: "QuickActions_CapturePhoto")
        } else if currentBingoBox?.proofRequired == "signature" {
            cell.bingoBoxActionIcon.image = #imageLiteral(resourceName: "QuickActions_Compose")
        } else {
            cell.bingoBoxActionIcon.image = nil
        }
        
        return cell
    }
    
  
}
