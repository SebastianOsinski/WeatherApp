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

    var weather: Weather? {
        didSet {
            debugPrint(weather)
            configureView()
        }
    }

    func configureView() {
        title = weather?.name
        conditionLabel?.text = weather?.condition
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

