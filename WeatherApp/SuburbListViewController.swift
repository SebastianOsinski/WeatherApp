//
//  SuburbListViewController.swift
//  WeatherApp
//
//  Created by Sebastian Osiński on 18.11.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class SuburbListViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var changeSortingStyleButton: UIBarButtonItem!
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    var weatherService = WeatherService()
    var weathers: [Weather]?
    var filteredWeathers: [Weather]?
    var currentSortingStyle: WeatherSortingStyle = .Alphabetically

    let dateFormatter = NSDateFormatter()
    let defaults = NSUserDefaults.standardUserDefaults()
    var fEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.tintColor = UIColor(red: 0.306, green: 0.651, blue: 0.890, alpha: 1.00)
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        self.configureSearchController()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userChangedDisplaySettings", name: NSUserDefaultsDidChangeNotification, object: nil)
        fEnabled = defaults.boolForKey("FahrenheitEnabled")
        
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .MediumStyle
        
        refresh()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Data loading
    func refresh(refreshControl: UIRefreshControl? = nil) {
        weatherService.getWeather { (weathers, error) in
            if let error = error {
                let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
                self.refreshControl?.endRefreshing()
                return
            }
            
            self.weathers = weathers
            self.filteredWeathers = weathers
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Sorting
    
    private func sortWeather() {
        switch currentSortingStyle {
            case .Alphabetically:
                weathers?.sortInPlace { $0.name < $1.name }
            case .ByTemperature:
                weathers?.sortInPlace { $0.temperatureInC > $1.temperatureInC }
            case .ByLastUpdate:
                weathers?.sortInPlace { $0.lastUpdateTimeStamp > $1.lastUpdateTimeStamp }
        }
        
        if searchController.active {
            filterWeathersWithText(searchController.searchBar.text)
        }
        
        self.tableView.reloadData()
    }
    
    func setCurrentSortingStyle(sortingStyle: WeatherSortingStyle) {
        currentSortingStyle = sortingStyle
        sortWeather()
    }

    @IBAction func changeSorting() {
        let ac = UIAlertController(title: "Choose sorting", message: nil, preferredStyle: .ActionSheet)
        
        ac.addAction(UIAlertAction(title: "Alphabetically", style: .Default) {(_) in self.setCurrentSortingStyle(.Alphabetically) })
        ac.addAction(UIAlertAction(title: "By temperature", style: .Default) {(_) in  self.setCurrentSortingStyle(.ByTemperature) })
        ac.addAction(UIAlertAction(title: "By last update date", style: .Default) {(_) in self.setCurrentSortingStyle(.ByLastUpdate) })
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        ac.popoverPresentationController?.sourceView = self.view
        ac.popoverPresentationController?.barButtonItem = self.changeSortingStyleButton
        self.presentViewController(ac, animated: true, completion: nil)
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
        cell.temperatureLabel.text =  fEnabled ? "\(weather?.temperatureInF?.description ?? "--")℉" : "\(weather?.temperatureInC?.description ?? "--")℃"
        
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
    }
    
    func filterWeathersWithText(searchText: String?) {
        if let searchText = searchText where searchText != "" {
            filteredWeathers = weathers?.filter { (weather) in
                let nameParts = weather.name.componentsSeparatedByString(" ").map { $0.lowercaseString }

                return nameParts.any { $0.hasPrefix(searchText.lowercaseString) }
            }
        } else {
            filteredWeathers = weathers
        }
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        filterWeathersWithText(searchString)
    }
    
    // MARK: - defaults changed
    func userChangedDisplaySettings() {
        fEnabled = defaults.boolForKey("FahrenheitEnabled")
        tableView.reloadData()
    }
    
}

