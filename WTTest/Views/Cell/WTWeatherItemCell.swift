//
//  WTWeatherItemCell.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import UIKit

class WTWeatherItemCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        icon.accessibilityIdentifier = "iconID"
        descriptionLabel.accessibilityIdentifier = "descriptionLabelID"
        tempLabel.accessibilityIdentifier = "tempLabelID"
        timeLabel.accessibilityIdentifier = "timeLabelID"
    }
}
