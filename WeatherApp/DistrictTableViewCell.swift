//
//  DistrictTableViewCell.swift
//  WeatherApp
//
//  Created by Sebastian Osiński on 18.11.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class DistrictTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
