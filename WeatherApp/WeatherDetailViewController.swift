//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Sebastian Osiński on 18.11.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var compassView: Compass!
    
    var placeholderView: UIView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var weather: Weather? {
        didSet {
            configureView()
        }
    }

    func configureView() {
        if let weather = weather {
            placeholderView?.hidden = true
            title = weather.name
            conditionLabel?.text = "\(weather.condition ?? "--")"
            windDirectionLabel?.text = weather.windDirection ?? "--"
            windSpeedLabel?.text = "\(weather.windSpeed?.description ?? "--")kph"
            
            if let windDirection = weather.windDirection {
                compassView?.setDirection(CardinalDirection(withString: windDirection) ?? .N)
            }
            
            let fEnabled = defaults.boolForKey("FahrenheitEnabled")
            
            if fEnabled {
                temperatureLabel?.text = "\(weather.temperatureInF?.description ?? "--")℉"
                feelsLikeLabel?.text = "Feels like \(weather.feelsLikeInF?.description ?? "--")℉"
            } else {
                temperatureLabel?.text = "\(weather.temperatureInC?.description ?? "--")℃"
                feelsLikeLabel?.text = "Feels like \(weather.feelsLikeInC?.description ?? "--")℃"
            }
        } else {
            placeholderView?.hidden = false
        }
    }
    
    // Placeholder view will be used in iPad and iPhone 6(s) Plus in landscape, when detail controller is displayed at the beginning, without any suburb selected
    func configurePlaceholderView() {
        placeholderView = UINib(nibName: "PlaceholderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView
        self.view.addSubview(placeholderView)
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["subview": placeholderView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["subview": placeholderView]))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "configureView", name: NSUserDefaultsDidChangeNotification, object: nil)
        
        configurePlaceholderView()
        configureView()
    }

}

