//
//  PlayGameViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-09.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PlayGameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var bingoCardCollectionView: UICollectionView!
    @IBOutlet weak var bingoCardFlow: UICollectionViewFlowLayout!
    
    var currentBingoCard: NSManagedObject?
    var contentsOfCurrentCard: [BoxContents]? = []
    
    let normalBoxCompleteColor = #colorLiteral(red: 0.3254901961, green: 0.4784313725, blue: 0.3529411765, alpha: 1)
    var boxCompleteColor = #colorLiteral(red: 0.3254901961, green: 0.4784313725, blue: 0.3529411765, alpha: 1)
    let boxCompleteFontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    let boxNotCompleteColor = #colorLiteral(red: 0.2784313725, green: 0.2901960784, blue: 0.2823529412, alpha: 1)
    let boxNotCompleteFontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
    let partyColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    
    let hapticSelection = UISelectionFeedbackGenerator()
    
    var confettiView: SAConfettiView = SAConfettiView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentBingoCard!.value(forKey: "title") as? String
        
        //self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        bingoCardCollectionView.dataSource = self
        bingoCardCollectionView.delegate = self
        
        bingoCardFlow.minimumLineSpacing = 0
        bingoCardFlow.minimumInteritemSpacing = 0
        bingoCardFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let totalWidth = view.frame.width
        
        let window = UIApplication.shared.windows[0].safeAreaInsets
        let topPadding = window.top
        let bottomPadding = window.bottom
        let totalHeight = self.view.frame.height - topPadding - bottomPadding - (self.navigationController?.navigationBar.frame.height)!
        
        let sizeOfGrid = currentBingoCard?.value(forKey: "cardSize") as? Int
        let widthOfCell = CGFloat(Int(totalWidth) / sizeOfGrid!)
        let heightOfCell = CGFloat(Int(totalHeight) / sizeOfGrid!)
        bingoCardFlow.itemSize = CGSize(width: widthOfCell, height: heightOfCell)

        
        // fetching card contents
        
        let titleOfCurrentCard = currentBingoCard!.value(forKey: "title") as? String
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<BoxContents> = BoxContents.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ownerCard.title == %@", titleOfCurrentCard!)
        
        do {
            contentsOfCurrentCard = try context.fetch(fetchRequest) as [BoxContents]
            
        } catch {
            print("Could not fetch card contents.", error.localizedDescription)
        }
        
        confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        confettiView.isUserInteractionEnabled = false
        confettiView.intensity = 1
        
        determineCelebration()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = bingoCardCollectionView.cellForItem(at: indexPath) as! BingoBox
        //let selectedBingoBox = contentsOfCurrentCard?[indexPath.row]
        let selectedBingoBox = contentsOfCurrentCard!.first(where: { Int($0.positionInCard) == indexPath.row })!
        //print(selectedCell.bingoBoxTitle.text!)
        
        // this is the haptic feedback on the bingo card
        hapticSelection.selectionChanged()
        
        if selectedBingoBox.complete == true {
            print(selectedCell.bingoBoxTitle.text! + " is going from complete to incomplete")
            selectedCell.backgroundColor = boxNotCompleteColor
            selectedCell.bingoBoxTitle.tintColor = boxNotCompleteFontColor
            selectedBingoBox.complete = false
        } else {
            print(selectedCell.bingoBoxTitle.text! + " is going from incomplete to complete")
            selectedCell.backgroundColor = boxCompleteColor
            selectedCell.bingoBoxTitle.tintColor = boxCompleteFontColor
            selectedBingoBox.complete = true
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            print("Could not save context on bingobox click.")
        }
        
        determineCelebration()
        
    }
    
    func cardIsCompleted() -> Bool {
        let completionPoint = currentBingoCard!.value(forKey: "completionPoint") as? String
        let sizeOfCard = currentBingoCard!.value(forKey: "cardSize") as? Float
        
        if completionPoint == "Single Line" {
            //print(contentsOfCurrentCard!, sizeOfCard!)
            if checkCardRows(size: sizeOfCard!)
            || checkCardColumns(size: sizeOfCard!)
                || checkCardDiagonals(size: sizeOfCard!) {
                return true
            }
            return false
        } else {
            for box in contentsOfCurrentCard! {
                if box.complete == false {
                    return false
                }
            }
            return true
        }
        
    }
    
    func checkCardRows(size: Float) -> Bool {
        
        var firstRowComplete = true
        var secondRowComplete = true
        var thirdRowComplete = true
        var fourthRowComplete = true
        var fifthRowComplete = true
        
        if size == 3 {
            fourthRowComplete = false
            fifthRowComplete = false
        } else if size == 4 {
            fifthRowComplete = false
        }
        
        for box in contentsOfCurrentCard! {
            let position = box.positionInCard
            
            switch(position) {
            case _ where position < size:
                //print("first row")
                if !box.complete {
                    //print("box ",  position, " is not complete!")
                    firstRowComplete = false
                }
            case _ where position < size * 2:
                //print("second row")
                if !box.complete {
                    //print("box ",  position, " is not complete!")
                    secondRowComplete = false
                }
            case _ where position < size * 3:
                //print("third row")
                if !box.complete {
                    //print("box ",  position, " is not complete!")
                    thirdRowComplete = false
                }
            case _ where position < size * 4:
                //print("fourth row")
                if !box.complete {
                    //print("box ",  position, " is not complete!")
                    fourthRowComplete = false
                }
            case _ where position < size * 5:
                //print("fifth row")
                if !box.complete {
                    //print("box ",  position, " is not complete!")
                    fifthRowComplete = false
                }
            default:
                print("while checking card rows, position was higher than size*5 which should not happen")
            }
        }
        if firstRowComplete || secondRowComplete || thirdRowComplete || fourthRowComplete || fifthRowComplete {
            print("row complete!")
            return true
        }
        return false
    }
    
    func checkCardColumns(size: Float) -> Bool {
        var firstColumnComplete = true
        var secondColumnComplete = true
        var thirdColumnComplete = true
        var fourthColumnComplete = true
        var fifthColumnComplete = true
        
        var firstColumn: [Float] = [0, size, size * 2, size * 3, size * 4]
        var secondColumn: [Float] = [0 + 1, size + 1, size * 2 + 1, size * 3 + 1, size * 4 + 1]
        var thirdColumn: [Float] = [0 + 2, size + 2, size * 2 + 2, size * 3 + 2, size * 4 + 2]
        var fourthColumn: [Float] = [0 + 3, size + 3, size * 2 + 3, size * 3 + 3, size * 4 + 3]
        var fifthColumn: [Float] = [0 + 4, size + 4, size * 2 + 4, size * 3 + 4, size * 4 + 4]
        
        switch(size) {
        case 3:
            firstColumn = [0, size, size * 2]
            secondColumn = [1, size + 1, size * 2 + 1]
            thirdColumn = [2, size + 2, size * 2 + 2]
        case 4:
            firstColumn = [0, size, size * 2, size * 3]
            secondColumn = [1, size + 1, size * 2 + 1, size * 3 + 1]
            thirdColumn = [2, size + 2, size * 2 + 2, size * 3 + 2]
            fourthColumn = [3, size + 3, size * 2 + 3, size * 3 + 3]
        case 5:
            firstColumn = [0, size, size * 2, size * 3, size * 4]
            secondColumn = [1, size + 1, size * 2 + 1, size * 3 + 1, size * 4 + 1]
            thirdColumn = [2, size + 2, size * 2 + 2, size * 3 + 2, size * 4 + 2]
            fourthColumn = [3, size + 3, size * 2 + 3, size * 3 + 3, size * 4 + 3]
            fifthColumn = [4, size + 4, size * 2 + 4, size * 3 + 4, size * 4 + 4]
        default:
            print("invalid size!")
        }
        
        if size == 3 {
            fourthColumnComplete = false
            fifthColumnComplete = false
        } else if size == 4 {
            fifthColumnComplete = false
        }
        
        for box in contentsOfCurrentCard! {
            switch(box.positionInCard) {
            case _ where firstColumn.contains(box.positionInCard):
                if !box.complete {
                    //print("I'm in the first column!")
                    firstColumnComplete = false
                }
            case _ where secondColumn.contains(box.positionInCard):
                if !box.complete {
                    //print("I'm in the second column!")
                    secondColumnComplete = false
                }
            case _ where thirdColumn.contains(box.positionInCard):
                if !box.complete {
                    //print("I'm in the third column!")
                    thirdColumnComplete = false
                }
            case _ where fourthColumn.contains(box.positionInCard):
                if !box.complete {
                    //print("I'm in the fourth column!")
                    fourthColumnComplete = false
                }
            case _ where fifthColumn.contains(box.positionInCard):
                if !box.complete {
                    //print("I'm in the fifth column!")
                    fifthColumnComplete = false
                }
            default:
                print("I'm not in a valid column!")
            }
        }
        if firstColumnComplete || secondColumnComplete || thirdColumnComplete || fourthColumnComplete || fifthColumnComplete {
            print("column complete!")
            return true
        }
        return false
    }
    
    func checkCardDiagonals(size: Float) -> Bool {
        switch(size) {
        case 3:
            let box0Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 0})?.complete
            let box4Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 4})?.complete
            let box8Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 8})?.complete
            
            if box0Complete! && box4Complete! && box8Complete! {
                return true
            }
            
            let box2Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 2})?.complete
            let box6Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 6})?.complete
            
            if box2Complete! && box4Complete! && box6Complete! {
                return true
            }
            
        case 4:
            let box0Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 0})?.complete
            let box5Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 5})?.complete
            let box10Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 10})?.complete
            let box15Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 15})?.complete
            
            if box0Complete! && box5Complete! && box10Complete! && box15Complete! {
                return true
            }
            
            let box3Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 3})?.complete
            let box6Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 6})?.complete
            let box9Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 9})?.complete
            let box12Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 12})?.complete
            
            if box3Complete! && box6Complete! && box9Complete! && box12Complete! {
                return true
            }
        case 5:
            let box0Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 0})?.complete
            let box6Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 6})?.complete
            let box12Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 12})?.complete
            let box18Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 18})?.complete
            let box24Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 24})?.complete
            
            if box0Complete! && box6Complete! && box12Complete! && box18Complete! && box24Complete! {
                return true
            }
            
            let box4Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 4})?.complete
            let box8Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 8})?.complete
            let box16Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 16})?.complete
            let box20Complete = contentsOfCurrentCard?.first(where: {$0.positionInCard == 20})?.complete
            
            if box4Complete! && box8Complete! && box12Complete! && box16Complete! && box20Complete! {
                return true
            }
        default:
            print("something went wrong in diagonal check")
        }
        
        return false
    }
    
    func cardCompleteCelebration() {
        boxCompleteColor = partyColor
        bingoCardCollectionView.reloadData()
        
        if !confettiView.isActive() {
            self.confettiView.startConfetti()
        }
    }
    
    func endCelebration() {
        boxCompleteColor = normalBoxCompleteColor
        self.confettiView.stopConfetti()
        bingoCardCollectionView.reloadData()
    }
    
    func determineCelebration() {
        if cardIsCompleted() {
            cardCompleteCelebration()
        } else {
            endCelebration()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cellToDeselect = bingoCardCollectionView.cellForItem(at: indexPath) as! BingoBox
        //let deselectedBingoBox = contentsOfCurrentCard?[indexPath.row]
        let deselectedBingoBox = contentsOfCurrentCard!.first(where: { Int($0.positionInCard) == indexPath.row })!
        
        if deselectedBingoBox.complete != true {
            cellToDeselect.backgroundColor = boxNotCompleteColor
            cellToDeselect.bingoBoxTitle.tintColor = boxNotCompleteFontColor
        }

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentsOfCurrentCard?.count ?? 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let currentBingoBox = contentsOfCurrentCard![indexPath.row]
        
        let currentBingoBox = contentsOfCurrentCard!.first(where: { Int($0.positionInCard) == indexPath.row })!
        
        let cell = bingoCardCollectionView.dequeueReusableCell(withReuseIdentifier: "BingoBox", for: indexPath as IndexPath) as! BingoBox
        if currentBingoBox.complete {
            cell.backgroundColor = boxCompleteColor
            cell.bingoBoxTitle.tintColor = boxCompleteFontColor
        } else {
            cell.backgroundColor = boxNotCompleteColor
            cell.bingoBoxTitle.tintColor = boxNotCompleteFontColor
        }
        cell.bingoBoxTitle.text = currentBingoBox.boxTitle
        cell.bingoBoxTitle.textAlignment = .center
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.6039215686, green: 0.8823529412, blue: 0.6156862745, alpha: 1)
        
        return cell
    }
    
    @IBAction func shareBingoCard(_ sender: Any) {
        
    }
    
}
