//
//  WTWeatherCell.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import UIKit

class WTWeatherCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateTimeLabel.accessibilityIdentifier = "dateTimeLabelID"
        collectionView.accessibilityIdentifier = "collectionViewID"
    }
}
