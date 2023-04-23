//
//  ChainReactionViewController2.swift
//  ComplexUI
//
//  Created by Vidhika Ahir on 22/04/23.
//

import UIKit

//enum Player {
//    case player1, player2, none
//}


class ChainReactionViewController2: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flagBG: UIView!
    
    @IBOutlet weak var XLbl: UILabel!
    
    @IBOutlet weak var maxBomb: UILabel!
    
    @IBOutlet weak var display1: UIView!
    
    @IBOutlet weak var display2: UIView!
    
    var blockArray : [BlockModel]? = []
    
    var blockCount = 10
    
    var numberOfBombs = 19
    
    var numberOfBombsPlaced = 0
    
    var widthOfCollectionView = 300//Int(UIScreen.main.bounds.width - 200)
    var heightOfCollectionView = 300//Int(UIScreen.main.bounds.height - 200)
    
    var flagSetOn = false;
    
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    var x : [Int]? = []
    
    var X : [Int]? = []
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        selectionFeedback.prepare()
        
        flagBG.backgroundColor = .gray
        display1.backgroundColor = .gray
        display2.backgroundColor = .gray
        
        maxBomb.textColor = .white
        XLbl.textColor = .white
        titleLbl.textColor = .white
        maxBomb.font = UIFont.boldSystemFont(ofSize: 20)
        XLbl.font = UIFont.boldSystemFont(ofSize: 20)
        titleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        
        flagBG.dropShadow()
        display1.dropShadow()
        display2.dropShadow()
        
        maxBomb.text = String(describing: numberOfBombs + 1)
        XLbl.text = String(describing: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(flagged))
        flagBG.isUserInteractionEnabled = true
        flagBG.addGestureRecognizer(tap)
        titleLbl.text = "🔴 FLAG"
        createData(maxBlocks: 99)
        
        
    }
    
    @objc func flagged(sender: UITapGestureRecognizer){
        flagSetOn = true
        visiblyDisableBtn()
    }
    
    func createData(maxBlocks : Int) {
        var blocks = 0...maxBlocks
        
        for bombs in 0...numberOfBombs  {
            x?.append(Int.random(in: blocks))
        }
        
        for block in blocks {
            if let X = x {
                if ((X.contains(block) ) ){
                    blockArray?.append(BlockModel(indexPath: block, number: "X"))
                }else{
                    blockArray?.append(BlockModel(indexPath: block, number: ""))
                }
            }
        }
        
        for block in blocks {
            var storeCount = 0
            var  checkConditions = [0]
            if ("\(block)".contains("0")){
                checkConditions = [-9,-10,+1, +10, +11]
            }else if("\(block)".contains("9")){
                if ("\(block - 10)".contains("9") ){
                    checkConditions = [-11, -10, -1, +9,+10]
                }else{
                    checkConditions = [+1,-1, +9, -9, +10, -10, +11, -11]
                    
                }
            }else {
                checkConditions = [+1,-1, +9, -9, +10, -10, +11, -11]
            }
            
            if ((blockArray?[block].number.contains("X") ?? false) == false){
                
                for condition in checkConditions {
                    if ((block + condition) > 0 && (block + condition) < 100 && (blockArray?[block + condition].number.contains("X") ?? false)) {
                        storeCount = storeCount + 1
                    }
                }
            }
            if blockArray?[block].number != "X" {
                blockArray?[block] = (BlockModel(indexPath: block, number: storeCount == 0 ? "" : "\(storeCount)"))
                
            }
        }
        
        collectionView.reloadData()
    }
}


//MARK: COLLECTION VIEW
extension ChainReactionViewController2 : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlockCell", for: indexPath) as! BlockCell
        
        cell.lbl.text = blockArray?[indexPath.row].number
        cell.lbl.textColor = .white
        //        cell.coveringView.alpha = 1
        //        cell.coveringView.backgroundColor = .gray
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        generateHaptic()
        if let cell = collectionView.cellForItem(at: indexPath) as? BlockCell {
            
            cell.coveringView.alpha = 0
            if (blockArray?[indexPath.row].number == ""){
                clearBlanks(index: indexPath)
            }
            else if (blockArray?[indexPath.row].number == "X"){
                if (flagSetOn){
                    cell.lbl.text = "🔴"
                    numberOfBombsPlaced += 1
                    X?.append(indexPath.row)
                    checkIfGameIsOver()
                }else{
                    gameOverAlert()
                }
            }
            cell.coveringView.alpha = 0
        }
        visiblyEnableBtn()
        XLbl.text = String(describing: numberOfBombsPlaced)
        flagSetOn = false
    }
    
    func clearBlanks(index : IndexPath){
        var indexArray : [IndexPath]? = []
        blockArray?.forEach({ block in
            if (block.number == ""){
                indexArray?.append(IndexPath(row: block.indexPath, section: 0))
                let cell = collectionView.cellForItem(at: IndexPath(row: block.indexPath, section: 0)) as! BlockCell
                cell.coveringView.alpha = 0
            }
        })
    }
    
    func displayAllBombs(){
        var indexArray : [IndexPath]? = []
        blockArray?.forEach({ block in
            if (block.number == "X"){
                indexArray?.append(IndexPath(row: block.indexPath, section: 0))
                let cell = collectionView.cellForItem(at: IndexPath(row: block.indexPath, section: 0)) as! BlockCell
                cell.coveringView.alpha = 0
            }
        })
    }
    
    func restart(){
        blockArray?.forEach({ block in
            let cell = collectionView.cellForItem(at: IndexPath(row: block.indexPath, section: 0)) as! BlockCell
            cell.coveringView.alpha = 1
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthOfCollectionView / blockCount - 1, height: heightOfCollectionView / blockCount - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func gameOverAlert(){
        displayAllBombs()
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        selectionFeedback.selectionChanged()
        
        let alert = UIAlertController(title: "Game Over !", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { action in
            
            self.restart()
            self.viewDidLoad()
            self.viewWillAppear(true)
            
            
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
        
    }
    
    func generateHaptic(){
        selectionFeedback.selectionChanged()
    }
    
    func visiblyDisableBtn(){
        titleLbl.text = "⚪️ FLAG"
        titleLbl.textColor = .systemGray
    }
    
    func visiblyEnableBtn(){
        titleLbl.text = "🔴 FLAG"
        titleLbl.textColor = .white
    }
    
    func checkIfGameIsOver(){
        if (X?.count == x?.count) {
            
            if X!.sorted() == x!.sorted() {
                let alert = UIAlertController(title: "YOU WON !", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { action in
                    self.viewDidLoad()
                    self.viewWillAppear(true)
                    
                }))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
            
            
        }
    }
}


//MARK: CELL
class BlockCell : UICollectionViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var coveringView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
