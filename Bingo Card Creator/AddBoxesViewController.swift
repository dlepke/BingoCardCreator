//
//  AddBoxesViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-09.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit

class AddBoxesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        addBoxToCardButton.layer.cornerRadius = 10
        addBoxToCardButton.layer.applySketchShadow()
        
        //tableview stuff
        addBoxesTableView.delegate = self
        addBoxesTableView.dataSource = self
        
        addBoxesTableView.tableFooterView = UIView()
        
        self.tableViewHeightConstraint.constant = addBoxesTableView.contentSize.height
        self.addBoxesTableView.needsUpdateConstraints()
        
        self.contentViewWidthConstraint.constant = self.view.frame.width
        self.contentViewHeightConstraint.constant = previewBingoCard.frame.height + addBoxesTableView.contentSize.height + addBoxToCardButton.frame.height
        
        self.contentView.needsUpdateConstraints()
        
        //collectionview stuff
        previewBingoCard.delegate = self
        previewBingoCard.dataSource = self
        
        previewBingoCardFlowLayout.minimumLineSpacing = 0
        previewBingoCardFlowLayout.minimumInteritemSpacing = 0
        previewBingoCardFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let totalWidth = view.frame.width

        let sizeOfGrid = 5
        let widthOfCell = CGFloat(Int(totalWidth) / sizeOfGrid)
        let heightOfCell = CGFloat(Int(totalWidth) / sizeOfGrid)
        previewBingoCardFlowLayout.itemSize = CGSize(width: widthOfCell, height: heightOfCell)
        
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addBoxesTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addBoxToCardButton: UIButton!
    
    @IBOutlet weak var previewBingoCard: UICollectionView!
    @IBOutlet weak var previewBingoCardFlowLayout: UICollectionViewFlowLayout!
    
    
    // begin collectionview stuff
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = previewBingoCard.dequeueReusableCell(withReuseIdentifier: "previewBingoBox", for: indexPath)
        
        cell.layer.borderColor = #colorLiteral(red: 0.3764705882, green: 0.3529411765, blue: 0.337254902, alpha: 0.5)
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    
    // begin tableview stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellPrototypes = ["labelTableCell", "titleTableCell", "detailsTableCell", "proofRequiredTableCell"]
        
        let cell = addBoxesTableView.dequeueReusableCell(withIdentifier: cellPrototypes[indexPath.section], for: indexPath)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 1:
            return "Box Title".uppercased()
        case 2:
            return "Box Details".uppercased()
        case 3:
            return "Proof of Completion".uppercased()
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        if section == 0 {
            headerView.frame.size = CGSize(width: 0, height: 0)
            return headerView
        }
        
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section > 0 {
            return 30
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
        
    }
}
