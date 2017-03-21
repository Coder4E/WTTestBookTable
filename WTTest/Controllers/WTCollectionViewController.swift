//
//  WTCollectionViewController.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import UIKit

class WTCollectionViewController: UICollectionViewController {
    
    // represents items for one single day
    var dataSource: Array<WTWeatherItem>?
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let items = dataSource {
            return items.count
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WTWeatherItemCellID", for: indexPath) as! WTWeatherItemCell
        
        if let dataSource = dataSource {
            let item = dataSource[indexPath.row]
            
            // set data to display in a cell
            cell.icon.image = UIImage(named: item.icon)
            cell.descriptionLabel.text = item.desc.capitalized
            cell.tempLabel.text = "\(item.temp) °C"
            cell.timeLabel.text = item.dt.formatHour()
        }
        
        return cell
    }
}
