//
//  AddBoxesViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-09.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit

class AddBoxesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        addBoxToCardButton.layer.cornerRadius = 10
        addBoxToCardButton.layer.applySketchShadow()
        
        addBoxesTableView.delegate = self
        addBoxesTableView.dataSource = self
        
        addBoxesTableView.tableFooterView = UIView()
        
//        addBoxesTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: addBoxesTableView.contentSize.height)
        
//        addBoxesTableView.sizeToFit()
        
        self.tableViewHeightConstraint.constant = addBoxesTableView.contentSize.height
        self.addBoxesTableView.needsUpdateConstraints()
    }
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var addBoxToCardButton: UIButton!
    
    
    @IBOutlet weak var addBoxesTableView: UITableView!
    
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
