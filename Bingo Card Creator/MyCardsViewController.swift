//
//  ViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-08.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit
import Foundation

class MyCardsViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    

    
    let sampleCardListArray: [String] = ["My First Card", "My Second Card", "My Third Card"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return sampleCardListArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Bingo Card Table Cell", for: indexPath)
        
        cell.textLabel?.text = sampleCardListArray[indexPath.row]
            
        return cell
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverView" {
            let vc = segue.destination

            let ppc = vc.popoverPresentationController
            ppc?.permittedArrowDirections = .any
            ppc?.delegate = self
            ppc?.barButtonItem = navigationItem.rightBarButtonItem
            ppc?.sourceView = sender as? UIView
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}




