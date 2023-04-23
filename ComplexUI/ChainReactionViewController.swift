//
//  ChainReactionViewController.swift
//  ComplexUI
//
//  Created by Vidhika Ahir on 19/04/23.
//
// Player 1 - red
// Player 2 = blue

import UIKit

enum user  {
    case user1, user2
}

class ChainReactionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var displayCurrentPlayerLbl: UILabel!
    
    @IBOutlet weak var gridView: UIView!
    
    var playingUser = user.user1
    
    var gridSize = 0
    
    var selectedIndex = IndexPath(row: -1, section: 0)
    
    var widthOfCollectionView = 300//Int(UIScreen.main.bounds.width - 200)
    var heightOfCollectionView = 300//Int(UIScreen.main.bounds.height - 200)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
        gridSizeAlert()
        
    }
    
    func initialise(){
        //        self.gridView.frame = CGRect(x: 100, y: 100, width: widthOfCollectionView, height: heightOfCollectionView)
        //
        //        self.gridView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        //        self.gridView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        //        self.gridView.widthAnchor.constraint(equalToConstant: CGFloat(widthOfCollectionView)).isActive = true
        //        self.gridView.heightAnchor.constraint(equalToConstant: CGFloat(heightOfCollectionView)).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func gridSizeAlert(){
        let alert = UIAlertController(title: "Select Grid Size", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "10x10", style: UIAlertAction.Style.default, handler: { action in
            self.gridSize = 10
            self.prepareGrid()
            
        }))
        alert.addAction(UIAlertAction(title: "20x20", style: UIAlertAction.Style.default, handler: { action in
            print("CLicked 20x20")
            
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func prepareGrid(){
        collectionView.reloadData()
    }
    
    func switchUser(){
        self.playingUser = self.playingUser == user.user1 ? user.user2 : user.user1
        self.displayCurrentPlayerLbl.text
        = self.playingUser == user.user1 ? "Player 1 Red" : "Player 2 Blue"
        self.displayCurrentPlayerLbl.textColor = self.playingUser == user.user1 ? .red : .blue
    }
    
    func selectedUser() -> Bool {
        
        if (self.playingUser == user.user1) {
            return false
        } else {
            return true
            
        }
    }
    
    func isPlayingUserSameAsGridUser(imageDetails : UIColor?) -> Bool{
        var returnBool = false
        
        if let imgDetails = imageDetails {
            let user = imgDetails == .red ? user.user1 : user.user2
            if (user == playingUser) {
                returnBool = true
            }else{
                returnBool = false
            }
        }
        return returnBool
    }
    
    //MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridSize * gridSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        
//        if (selectedIndex.row - 1) == (indexPath.row - 1) {
//            cell.tag = 0
//           cell.imageView.image = selectedUser() ? Common.blue2  : Common.red2
//        }
//
        
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("INDEXPATH --> \(indexPath.row) \(indexPath.section)")
        
        if let cell = collectionView.cellForItem(at: indexPath) as? GridCell {
            print(cell.tag)
            
            var getImageString = String(describing: cell.imageView.image)
            
            
            var isPlayingUserSameAsGrid = isPlayingUserSameAsGridUser(imageDetails : getImageString.contains("red") ? .red : getImageString.contains("blue") ? .blue : nil)
            
            if (cell.tag == 0){
                cell.imageView.image = selectedUser() ? Common.red1 : Common.blue1
                switchUser()
                cell.tag = cell.tag + 1
            }
            else if (isPlayingUserSameAsGrid){
                if (cell.tag == 1) {
                    cell.imageView.image = selectedUser() ? Common.blue2  : Common.red2
                    switchUser()
                    cell.tag = cell.tag + 1
                }else if (cell.tag == 2){
                    cell.imageView.image = selectedUser() ? Common.blue3 :  Common.red3
                    switchUser()
                    cell.tag = cell.tag + 1
                }else if (cell.tag == 3){
                    cell.imageView.image = selectedUser() ? nil : nil
                    switchUser()
                    cell.tag = cell.tag + 1
                    selectedIndex = indexPath
//                    collectionView.reloadItems(at: [indexPath])

                }
            }
          
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthOfCollectionView / gridSize - 1, height: heightOfCollectionView / gridSize - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //MARK: BLOW UP
    
}


class GridCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
}

extension CGFloat {
    static func randomValue() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(
            red:   .randomValue(),
            green: .randomValue(),
            blue:  .randomValue(),
            alpha: 1.0
        )
    }
}

