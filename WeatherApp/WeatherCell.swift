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
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var tempCel: UILabel!
    @IBOutlet weak var tempFeh: UILabel!
    
    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    let imageUrl = "http://openweathermap.org/img/w/"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    public func updateCell(weather: Weather){ //weatherDataToDisplay[indexPath.row]
        let currdate = weather.day
        let makeformat = currdate.description
        let index = makeformat.index(makeformat.startIndex, offsetBy: 10)
        let finalformat = makeformat.substring(to: index)
        
        if let weekday = getDayOfWeek(finalformat){
            day.text = days[weekday-1]
        }else{
            print("Bad input")
        }
        
        let imgUrl = "\(imageUrl)\(weather.icon).png"
        // print("imageurl \(imgUrl)")
        ThumbImage.sd_setImage(with: URL(string: imgUrl))
        //cell.day.text = weatherDataToDisplay[indexPath.row].day
        tempFeh.text = String(format : "%.2f °F", weather.tempFeh * 9/5 - 459.67)
        tempCel.text = String(format : "%.2f °C", weather.tempFeh - 273)
        weatherLabel.text = weather.weatherType
    }

    

}
