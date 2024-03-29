//
//  Compass.swift
//  WeatherApp
//
//  Created by Sebastian Osiński on 19.11.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class Compass: UIView {
    
    var plateImageView: UIImageView!
    var needleImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCompass()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureCompass()
    }
    
    private func configureCompass() {
        self.backgroundColor = UIColor.clearColor()
        let compassPlate = UIImage(named: "CompassPlate")!
        let needle = UIImage(named: "CompassNeedle")!
        
        let needleAspectRatio = needle.size.width / needle.size.height
        plateImageView = UIImageView(image: compassPlate)
        needleImageView = UIImageView(image: needle)
        
        self.addSubview(plateImageView)
        self.addSubview(needleImageView)
        
        plateImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["subview": plateImageView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["subview": plateImageView]))

        needleImageView.translatesAutoresizingMaskIntoConstraints = false
        let xConstraint = NSLayoutConstraint(item: needleImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: needleImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: needleImageView, attribute: .Width, relatedBy: .Equal,
            toItem: self, attribute: .Height, multiplier: 0.8 * needleAspectRatio, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: needleImageView, attribute: .Height, relatedBy: .Equal,
            toItem: self, attribute: .Height, multiplier: 0.8, constant: 0)
        
        self.addConstraints([widthConstraint, heightConstraint, xConstraint, yConstraint])
    }
    
    private func setNeedleAngle(angle: CGFloat) {
        needleImageView.transform = CGAffineTransformMakeRotation(angle)
    }
    
    func setDirection(direction: CardinalDirection) {
        UIView.animateWithDuration(3, delay: 0.5, options: [], animations: {
            self.setNeedleAngle(direction.angleFromNorth)
            }, completion: nil)
    }
}
