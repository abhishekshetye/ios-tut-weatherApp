//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Abhishek's iMac on 7/22/17.
//  Copyright © 2017 abhishek. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var ThumbImage: UIImageView!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var tempCel: UILabel!
    @IBOutlet weak var tempFeh: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}
