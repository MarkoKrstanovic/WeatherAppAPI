//
//  ViewController.swift
//  WeatherAppAPI
//
//  Created by Martin Berger on 10/31/17.
//  Copyright © 2017 Martin Berger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    @IBAction func getWeather(_ sender: Any) {
        if let city = textField.text {
            let correctCity = city.replacingOccurrences(of: " ", with: "-")
            if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(correctCity)&appid=0db715961c06e0843f85a5842322581e&units=metric") {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if let urlContent = data {
                            do {
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                if let name = jsonResult["name"] as? String {
                                    if let country = (jsonResult["sys"] as? NSDictionary)?["country"] as? String {
                                        if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                                            if let temp = (jsonResult["main"] as? NSDictionary)?["temp"] as? Float {
                                                if let pressure = (jsonResult["main"] as? NSDictionary)?["pressure"] as? Float {
                                                    if let humidity = (jsonResult["main"] as? NSDictionary)?["humidity"] as? Float {
                                                        if let lat = (jsonResult["coord"] as? NSDictionary)?["lat"] as? Float {
                                                            if let lon = (jsonResult["coord"] as? NSDictionary)?["lon"] as? Float {
                                                                if let windSpeed = (jsonResult["wind"] as? NSDictionary)?["speed"] as? Float {
                                                                    DispatchQueue.main.async(execute: {
                                                                        self.weatherLabel.text = "Name: \(name) \n Country: \(country) \n description: \(description) \n temperature: \(String(temp))°C \n pressure: \(String(pressure)) \n humidity: \(humidity) \n longitude: \(lon) \n latitude: \(lat) \n wind speed: \(windSpeed)"
                                                                    })
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    DispatchQueue.main.async(execute: {
                                        self.weatherLabel.text = "There is no weather data for this location! \n Please try again!"
                                        })
                                    }
                            } catch {
                                    print("error")
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}

