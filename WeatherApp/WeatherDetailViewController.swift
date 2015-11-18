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
    
    

    var weather: Weather? {
        didSet {
            debugPrint(weather)
            configureView()
        }
    }

    func configureView() {
        if let weather = weather {
            title = weather.name
            conditionLabel?.text = "Condition: \(weather.condition ?? "--")"
            windLabel?.text = weather.wind ?? "Wind: --"
            
            temperatureLabel?.text = "Temperature: \(weather.temperature?.description ?? "--")"
            feelsLikeLabel?.text = "Feels like: \(weather.feelsLike?.description ?? "--")"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

