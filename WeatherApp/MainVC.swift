//
//  ViewController.swift
//  WeatherApp
//
//  Created by Abhishek's iMac on 7/22/17.
//  Copyright © 2017 abhishek. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var BannerWeatherName: UILabel!
    @IBOutlet weak var CurrentLocationLabel: UILabel!
    @IBOutlet weak var CurrentTemp: UILabel!
    @IBOutlet weak var CurrentDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    let months = ["Jan", "Feb", "March", "April", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec" ]
    
    let imageUrl = "http://openweathermap.org/img/w/"
    
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
                    
                    var today: String = ""
                    var weatherType: String = ""
                    var currTemp: Double = 0.0
                    var location: String = ""
                    var icon: String = ""
                    
                    let readableJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                    
                    let items = readableJson?["weather"]
                    
                    if let weat = items?[0] as? [String: Any] {
                        weatherType = (weat["main"] as? String)!
                        let weat_long = weat["description"] as? String
                        icon = (weat["icon"] as? String)!
                    }
                    
                    if let main = readableJson!["main"] as? [String: Any] {
                        currTemp = (main["temp"] as? Double)!
                        let humidity = main["humidity"] as? Double
                        let pressure = main["pressure"] as? Double
                        
                    }
                    let da = readableJson?["dt"] as? Double
                    let date = NSDate(timeIntervalSince1970: da!)
                    let weather = Weather(weatherType: weatherType, tempCel: currTemp, tempFeh: currTemp, day: (date as? Date)!, icon: icon)
                    self.updateBanner(weather: weather)
                    
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
                        var icon: String = ""

                        if let weat = weatherdatas?[0] as? [String: Any] {
                            weat_short = (weat["main"] as? String)!
                            weat_long = (weat["description"] as? String)!
                            icon = (weat["icon"] as? String)!
                            print("\(weat_short) long \(weat_long)")
                        }
                        
                        //temperature
                        if let main = data["temp"] as? [String: Any]{
                            tempFeh = (main["day"] as? Double)!
                        }
                        
                        //date dt_txt
                        let da = data["dt"] as? Double
                        let date = NSDate(timeIntervalSince1970: da!)
                        
                        print("Date \(date) weather is \(weat_short) temp is \(tempFeh)")
                        let weather = Weather(weatherType: weat_short, tempCel: tempFeh, tempFeh: tempFeh, day: date as Date, icon: icon)
                        self.weatherDataToDisplay.append(weather)
                        
                    }
                    self.reloadData()
                    
                }
            }
            catch{
                print(error)
            }
        })
        
    }
    
    private func updateBanner(weather: Weather){
        let date = weather.day
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        CurrentDateLabel.text = "Today, \(day) \(months[month-1]) \(year)"
        let imgUrl = "\(imageUrl)\(weather.icon).png"
        bannerImage.sd_setImage(with: URL(string: imgUrl))
        CurrentTemp.text = String(format : "%.2f °F", weather.tempFeh * 9/5 - 459.67)
        //tempCel.text = String(format : "%.2f °C", weather.tempFeh - 273)
        BannerWeatherName.text = weather.weatherType
    }
    
    private func reloadData(){
        tableView.reloadData()
    }
    

    //table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataToDisplay.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? WeatherCell {
            
            cell.updateCell(weather: weatherDataToDisplay[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
}

