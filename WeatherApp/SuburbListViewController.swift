//
//  SuburbListViewController.swift
//  WeatherApp
//
//  Created by Sebastian Osiński on 18.11.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class SuburbListViewController: UITableViewController, UISearchResultsUpdating {
    
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var detailViewController: WeatherDetailViewController? = nil
    
    var weatherService = WeatherService()
    var weathers: [Weather]?
    var filteredWeathers: [Weather]?
    var currentSortingStyle: WeatherSortingStyle = .Alphabetically

    var dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        configureSearchController()
        
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .MediumStyle
        
        let service = WeatherService()
        service.getWeather { (weathers) in
            self.weathers = weathers
            self.filteredWeathers = weathers
  
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? WeatherDetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - sorting
    
    private func sortWeather() {
        switch currentSortingStyle {
        case .Alphabetically:
            weathers?.sortInPlace { $0.name < $1.name }
        case .ByTemperature:
            weathers?.sortInPlace { $0.temperature > $1.temperature }
        case .ByLastUpdate:
            weathers?.sortInPlace { $0.lastUpdateTimeStamp > $1.lastUpdateTimeStamp }
        }
        
        if searchController.active {
            filterWeathersWithText(searchController.searchBar.text)
        }
        
        tableView.reloadData()
    }
    
    func setCurrentSortingStyle(sortingStyle: WeatherSortingStyle) {
        currentSortingStyle = sortingStyle
        sortWeather()
    }

    @IBAction func changeSorting() {
        let ac = UIAlertController(title: "Choose sorting", message: nil, preferredStyle: .Alert)
        
        ac.addAction(UIAlertAction(title: "Alphabetically", style: .Default) {(_) in self.setCurrentSortingStyle(.Alphabetically) })
        ac.addAction(UIAlertAction(title: "By temperature", style: .Default) {(_) in  self.setCurrentSortingStyle(.ByTemperature) })
        ac.addAction(UIAlertAction(title: "By last update date", style: .Default) {(_) in self.setCurrentSortingStyle(.ByLastUpdate) })
        
        presentViewController(ac, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let weather = searchController.active ? filteredWeathers?[indexPath.row] : weathers?[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! WeatherDetailViewController
                controller.weather = weather
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredWeathers?.count ?? 0
        } else {
            return weathers?.count ?? 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SuburbCell", forIndexPath: indexPath) as! SuburbTableViewCell
        
        let weather = searchController.active ? filteredWeathers?[indexPath.row] : weathers?[indexPath.row]
        cell.nameLabel.text = weather?.name
        cell.temperatureLabel.text = "\(weather?.temperature?.description ?? "--")℃"
        
        let dateString: String
        
        if let date = weather?.lastUpdate {
            dateString = dateFormatter.stringFromDate(date)
        } else {
            dateString = "--"
        }
        cell.updatedLabel.text = dateString
        return cell
    }
    
    // MARK: - Search Controller
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search districts..."
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.barTintColor = UIColor(red: 0.306, green: 0.651, blue: 0.890, alpha: 1.00)
        
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height)
    }
    
    func filterWeathersWithText(searchText: String?) {
        if let searchText = searchText where searchText != "" {
            filteredWeathers = weathers?.filter { $0.name.componentsSeparatedByString(" ").any { $0.hasPrefix(searchText) } }
        } else {
            filteredWeathers = weathers
        }
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        filterWeathersWithText(searchString)
    }
    
}

