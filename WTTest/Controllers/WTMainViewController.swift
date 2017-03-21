//
//  WTMainViewController.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import UIKit

class WTMainViewController: UIViewController, WTNetworkDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // dependencies
    var requestSender: WTRequestSender!
    var apiInterface: WTRequestEndpoints!
    
    // the key of these dictionaries is indexPath.row
    private var collectionsHolder = Dictionary<Int,WTCollectionViewController>()
    private var collectionsData = Dictionary<Int,Array<WTWeatherItem>>()
    
    var dataSource: WTWeather?
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(WTMainViewController.refreshData(sender:)), for: UIControlEvents.valueChanged)
        self.table.refreshControl = refreshControl
        
        // Initialise the apiInterface
        let requestFactory = WTRequestFactory()
        let parser = WTResponseParser()
        requestSender = WTRequestSender(requestFactory: requestFactory, parser: parser, delegate: self)
        apiInterface = WTRequestEndpoints(requestSender: requestSender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refreshData(sender: refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    
    /**
     Divides WeatherItems by day and put each day in the collectionsData Dictionary.
     */
    private func initCollectionViewsDataSources(items: Array<WTWeatherItem>) {
        
        var currentDay = items.first?.dt.formatDate()
        var groupIndex = 0
        var currentDayItems = Array<WTWeatherItem>()
        
        for item in items {
            
            if item.dt.formatDate() == currentDay {
                currentDayItems.append(item)
            } else {
                collectionsData[groupIndex] = currentDayItems
                currentDayItems.removeAll()
                currentDayItems.append(item)
                currentDay = item.dt.formatDate()
                groupIndex += 1
            }
        }
        
        collectionsData[groupIndex] = currentDayItems
    }
    
    @objc private func refreshData(sender: UIRefreshControl) {
        
        // use the last city to refresh data, default city (London) if not existing
        let lastCity = (dataSource?.cityName ?? "").isEmpty ? "London" : dataSource?.cityName
        hideSearchBar()
        // call get weather endpoint
        apiInterface.getWeather(city: lastCity!)
    }
    
    private func showErrorAlert() {
        
        let alertController = UIAlertController(title: "Sorry!", message: "An error has occured;\nPlease try again later.", preferredStyle: .alert)
        
        // Create the actions
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        // Add the actions
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func hideSearchBar(delay: Double = 0) {
        UIView.animate(withDuration: 0.2, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.table.contentOffset.y = self.searchBar.bounds.height
        }, completion: nil)
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
            self.hideSearchBar()
        }
    }
    
    // MARK: SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        hideSearchBar()
        if let city = searchBar.text, !city.isEmpty {
            apiInterface.getWeather(city: city)
        }
        searchBar.text = ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        hideSearchBar()
        searchBar.text = ""
    }
    
    // filter to allow only chars
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // \p{L} matches any Unicode base letter, and \p{M} matches any diacritic
        let regExp = "^[\\p{L}\\p{M}]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regExp)
        
        if predicate.evaluate(with: text) || text.isEmpty || text == "\n"  || text == "'" || text == " " {
            return true
        }
        
        return false
    }
    
    // MARK: TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectionsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID: String = "WTWeatherCellID"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! WTWeatherCell
        var collectionRowController: WTCollectionViewController
        // Create a CollectionViewController for the CollectionView in this row
        // if it doesn't exist, get it from memory if it had already been created
        if let collectionController = collectionsHolder[indexPath.row] {
            collectionRowController = collectionController
        } else {
            collectionRowController = WTCollectionViewController()
            collectionRowController.view = cell.collectionView
            collectionsHolder[indexPath.row] = collectionRowController
        }
        
        cell.dateTimeLabel.text = collectionsData[indexPath.row]?.first?.dt.friendlyDate()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // get the CollectionViewController for this row
        let collectionRowController = collectionsHolder[indexPath.row]
        // set the datasource for the CollecionView
        (collectionRowController?.view as! UICollectionView).dataSource = collectionRowController
        // set the datasource for the CollecionViewController
        collectionRowController?.dataSource = collectionsData[indexPath.row]
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // CollectionViewController no longer needed
        collectionsHolder[indexPath.row] = nil
    }
    
    //MARK: WTNetworkDelegate
    
    func requestProcessed(type: WTRequestType, data: Any) {
        
        if let weather = data as? WTWeather,
            type == .GetWeather {
        
            self.title = "\(weather.cityName) (\(weather.country.lowercased())) Weather"
            
            // clear CollectionViewControllers and relative dataSources from memory
            collectionsHolder.removeAll()
            collectionsData.removeAll()
            
            self.dataSource = weather
            initCollectionViewsDataSources(items: weather.items)
            self.table.reloadData()
            print("Data received")
        }
    }
    
    func requestFailed(type: WTRequestType, httpCode: Int?) {
        
        print("Error receiving data")
        refreshControl.endRefreshing()
        showErrorAlert()
    }
    
}
