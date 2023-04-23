//
//  ViewController.swift
//  ComplexUI
//
//  Created by Vidhika Ahir on 02/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var sampleCollectionView: UICollectionView!
    
    let searchBar = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

    }

    func setupUI(){
        sampleCollectionView.showsHorizontalScrollIndicator = false
        if let layout = sampleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            
        }
    }

 
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sampleCollectionView.dequeueReusableCell(withReuseIdentifier: "SampleCollectionCell", for: indexPath) as! SampleCollectionCell
        cell.sampleImg.image = UIImage(systemName: "info.circle")
        cell.titleLabel.text = "YO"
        cell.subTitleLabel.text = "YO2"
        return cell
    }
    
    
    
    
    
    
}


class SampleCollectionCell : UICollectionViewCell{
    @IBOutlet weak var pictureView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var sampleImg: UIImageView!
    
}
