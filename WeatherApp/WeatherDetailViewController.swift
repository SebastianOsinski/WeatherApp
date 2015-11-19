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
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var placeholderView: UIView!
    
    var weather: Weather? {
        didSet {
            debugPrint(weather)
            configureView()
        }
    }

    func configureView() {
        if let weather = weather {
            placeholderView?.hidden = true
            title = weather.name
            conditionLabel?.text = "\(weather.condition ?? "--")"
            windLabel?.text = weather.wind ?? "Wind: --"
            
            temperatureLabel?.text = "\(weather.temperature?.description ?? "--")℃"
            feelsLikeLabel?.text = "Feels like: \(weather.feelsLike?.description ?? "--")℃"
        } else {
            placeholderView?.hidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

}

