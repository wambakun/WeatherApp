//
//  WeatherController.swift
//  WeatherApp
//
//  Created by DSMacbook on 18/10/19.
//  Copyright © 2019 DSMacbook. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import CoreLocation

class WeatherController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    let gradientlayer = CAGradientLayer()
    let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
    var lat = 11.344533
    var lon = 104.33322
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientlayer)
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
             switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                   guard let currentLocation = locationManager.location else {
                       return
                    print("ok")
                   }
                lat = currentLocation.coordinate.latitude
                lon = currentLocation.coordinate.longitude
                }
        } else {
            print("Location services are not enabled")
        }
        // Do any additional setup after loading the view.
        test()
    }
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        print(lat,lon)
        
//        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=11.344533&lon=104.33322&appid=aa420b8e7557cbf36ed2928091fc78fc&units=metric", method: .get).responseJS
//            response in
//            print(response)
//            self.activityIndicator.stopAnimating()
//            if let responseStr = response.result.value{
//                let jsonResponse = JSON(responseStr)
//                let jsonWeather = jsonResponse["weather"].array![0]
//                let jsonTemp = jsonResponse["main"]
//                let iconName = jsonWeather["icon"].stringValue
//
//                self.locationLabel.text = jsonResponse["name"].stringValue
//                self.imageWeather.image = UIImage(named: iconName)
//                self.statusLabel.text = jsonWeather["main"].stringValue
//                self.numberLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
//                let date = Date()
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "EEEE"
//                self.dayLabel.text = dateFormatter.string(from: date)
//
//                let suffix = iconName.suffix(1)
//
//                if(suffix == "n"){
//                    self.setGreyGradientLayer()
//                }else{
//                    self.setBlueGradientBackground()
//                }
//            }
//
//        }
        
        
    }
    
    func test(){
        print(lat,lon)
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=aa420b8e7557cbf36ed2928091fc78fc&units=metric", method: .get,encoding: JSONEncoding.default, headers: nil).responseJSON {
                        response in
                    print(response)
                        switch response.result {
                            
                        case .success:
                            print(response)
                            
                            self.activityIndicator.stopAnimating()
                                        if let responseStr = response.result.value{
                                            let jsonResponse = JSON(responseStr)
                                            let jsonWeather = jsonResponse["weather"].array![0]
                                            let jsonTemp = jsonResponse["main"]
                                            let iconName = jsonWeather["icon"].stringValue
                            
                                            self.locationLabel.text = jsonResponse["name"].stringValue
                                            self.imageWeather.image = UIImage(named: iconName)
                                            self.statusLabel.text = jsonWeather["main"].stringValue
                                            self.numberLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                                            let date = Date()
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "EEEE"
                                            self.dayLabel.text = dateFormatter.string(from: date)
                            
                                            let suffix = iconName.suffix(1)
                            
//                                            if(suffix == "n"){
//                                                self.setGreyGradientLayer()
//                                            }else{
//                                                self.setBlueGradientBackground()
//                                            }
                                        }
 
                        case .failure(let error):
                            
                            print(error)
                        }
                    }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }


    func setBlueGradientBackground(){
        let topColor = UIColor(red: 95.0/255.0,green: 165.0/255.0,blue: 1.0,alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0,green: 114.0/255.0,blue: 184.0/255.0,alpha: 1.0).cgColor
        
        gradientlayer.frame = view.bounds
        gradientlayer.colors = [topColor,bottomColor]
    }
    
    func setGreyGradientLayer(){
        let topColor = UIColor(red: 151.0/255.0,green: 151.0/255.0,blue: 151.0/255.0,alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0,green: 72.0/255.0,blue: 72.0/255.0,alpha: 1.0).cgColor
        
        gradientlayer.frame = view.bounds
        gradientlayer.colors = [topColor,bottomColor]
    }

}
