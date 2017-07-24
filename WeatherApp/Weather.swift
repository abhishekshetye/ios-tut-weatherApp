//
//  Weather.swift
//  WeatherApp
//
//  Created by Abhishek's iMac on 7/22/17.
//  Copyright © 2017 abhishek. All rights reserved.
//

import Foundation

class Weather {
    
    var weatherType: String = ""
    var tempCel: Double = 0.0
    var tempFeh: Double = 0.0
    var day: Date
    
    init(weatherType: String, tempCel: Double, tempFeh: Double, day: Date){
        self.weatherType = weatherType
        self.tempCel = tempCel
        self.tempFeh = tempFeh
        self.day = day
    }
    
}
