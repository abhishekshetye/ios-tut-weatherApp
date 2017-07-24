//
//  ViewController.swift
//  WeatherApp
//
//  Created by Abhishek's iMac on 7/22/17.
//  Copyright © 2017 abhishek. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var BannerWeatherName: UILabel!
    @IBOutlet weak var CurrentLocationLabel: UILabel!
    @IBOutlet weak var CurrentTemp: UILabel!
    @IBOutlet weak var CurrentDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    let url = "http://api.openweathermap.org/data/2.5/weather?q=Mumbai&APPID=43a80028cf7fc1b34a515f437a0788b8"
    
    let forecastUrl = "http://api.openweathermap.org/data/2.5/forecast/daily?q=Mumbai&APPID=43a80028cf7fc1b34a515f437a0788b8"
    
    var weatherDataToDisplay = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getCurrentWeather()
        
    }

    
    //alamofire 
    func getCurrentWeather(){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            
            do{
                if let data = response.data{
                    let readableJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                    
//                    let coord = readableJson!["coord"] as? [String: Any]
//                    let lon = coord?["lon"] as? Double
//                    print("Longitude is \(lon) ")
                    let items = readableJson?["weather"]
                    
                    if let weat = items?[0] as? [String: Any] {
                        let weat_short = weat["main"] as? String
                        let weat_long = weat["description"] as? String
                        print("\(weat_short) long \(weat_long)")
                    }
                    
                    if let main = readableJson!["main"] as? [String: Any] {
                        let temp = main["temp"] as? Double
                        let humidity = main["humidity"] as? Double
                        let pressure = main["pressure"] as? Double
                        print("\(temp) humidity \(humidity) pressure \(pressure) ")
                    }
                    }else{
                        print("Data not found")
                }
            }catch {
                print(error)
            }
        })
        
        
        //forecast
        Alamofire.request(forecastUrl).responseJSON(completionHandler: {
            response in
            
            do{
                if let data = response.data{
                    let readableJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    
                    let datas = readableJson?["list"] as? [[String: Any]]
                    
                    for data in datas!{
                        
                        let weatherdatas = data["weather"] as? [[String: Any]]
                        var weat_short: String = ""
                        var weat_long: String = ""
                        var tempFeh: Double = 0.0

                        if let weat = weatherdatas?[0] as? [String: Any] {
                            weat_short = (weat["main"] as? String)!
                            weat_long = (weat["description"] as? String)!
                            print("\(weat_short) long \(weat_long)")
                        }
                        
                        //temperature
                        if let main = data["temp"] as? [String: Any]{
                            tempFeh = (main["day"] as? Double)!
                        }
                        
                        //date dt_txt
                        let da = data["dt"] as? Double
                        let date = NSDate(timeIntervalSince1970: da!)
                        //let date = ddate.description
                        
                        print("Date \(date) weather is \(weat_short) temp is \(tempFeh)")
                        let weather = Weather(weatherType: weat_short, tempCel: tempFeh, tempFeh: tempFeh, day: date as Date)
                        self.weatherDataToDisplay.append(weather)
                        
                    }
                    self.reloadData()
                    
                    
                    
                    
//                    if let items = readableJson?["list"]{
//                        
//                        for item  in items{
//                            
//                            if let it = item as? [String: Any]{
//                                //get weather
//                                let weatherdata = it["weather"]
//                                var weat_short: String = ""
//                                var weat_long: String = ""
//                                
//                                if let weat = weatherdata?[0] as? [String: Any] {
//                                    weat_short = (weat["main"] as? String)!
//                                    weat_long = (weat["description"] as? String)!
//                                    print("\(weat_short) long \(weat_long)")
//                                }
//                                
//                                //date dt_txt
//                                let date = it["date"] as? String
//                                print("Date \(date) weather is \(weat_short)")
//
//                            }
//                        }
                    //}
                }
            }
            catch{
                print(error)
            }
        })
        
    }
    
    func reloadData(){
        tableView.reloadData()
    }
    

    //table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataToDisplay.count
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? WeatherCell {
            
            
            if weatherDataToDisplay.count > 0 {
                
                let currdate = weatherDataToDisplay[indexPath.row].day
                let makeformat = currdate.description
                let index = makeformat.index(makeformat.startIndex, offsetBy: 10)
                let finalformat = makeformat.substring(to: index)
                if let weekday = getDayOfWeek(finalformat){
                    cell.day.text = days[weekday-1]
                }else{
                    print("Bad input")
                }
                
                //cell.day.text = weatherDataToDisplay[indexPath.row].day
                cell.tempFeh.text = String(format : "%.2f °F", weatherDataToDisplay[indexPath.row].tempFeh * 9/5 - 459.67)
                cell.tempCel.text = String(format : "%.2f °C", weatherDataToDisplay[indexPath.row].tempFeh - 273)
                cell.weather.text = weatherDataToDisplay[indexPath.row].weatherType
                
                cell.ThumbImage.image = UIImage(named: "cloudy.png")
            }
            
            //cell.day.text = weatherDataToDisplay?[indexPath.row].day
            return cell
        }
        
        return UITableViewCell()
    }
    
}

