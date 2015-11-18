//
//  MasterViewController.swift
//  WeatherApp
//
//  Created by Sebastian Osiński on 18.11.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class SuburbListViewController: UITableViewController {

    var detailViewController: WeatherDetailViewController? = nil
    
    var weatherService = WeatherService()
    var weathers: [Weather]?

    var dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .MediumStyle
        
        let service = WeatherService()
        service.getWeather { (weathers) in
            self.weathers = weathers
  
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? WeatherDetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sortWeather(sortingStyle: WeatherSortingStyle) {
        switch sortingStyle {
        case .Alphabetically:
            weathers?.sortInPlace { $0.name < $1.name }
        case .ByTemperature:
            weathers?.sortInPlace { $0.temperature > $1.temperature }
        case .ByLastUpdate:
            weathers?.sortInPlace { $0.lastUpdateTimeStamp > $1.lastUpdateTimeStamp }
        }
        tableView.reloadData()
    }

    @IBAction func changeSorting() {
        let ac = UIAlertController(title: "Choose sorting", message: nil, preferredStyle: .Alert)
        
        ac.addAction(UIAlertAction(title: "Alphabetically", style: .Default) {(action) in  self.sortWeather(.Alphabetically) })
        ac.addAction(UIAlertAction(title: "By temperature", style: .Default) {(action) in  self.sortWeather(.ByTemperature) })
        ac.addAction(UIAlertAction(title: "By last update date", style: .Default) {(action) in  self.sortWeather(.ByLastUpdate) })
        
        presentViewController(ac, animated: true) { () -> Void in
            
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let weather = weathers?[indexPath.row]
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
        return weathers?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SuburbCell", forIndexPath: indexPath) as! SuburbTableViewCell
        
        let weather = weathers?[indexPath.row]
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

}

