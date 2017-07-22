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
    
    let url = "http://api.openweathermap.org/data/2.5/weather?q=Mumbai&APPID=43a80028cf7fc1b34a515f437a0788b8"
    
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
    }
    

    //table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

