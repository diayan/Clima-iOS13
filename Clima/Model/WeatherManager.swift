//
//  WeatherManager.swift
//  Clima
//
//  Created by diayan siat on 25/07/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error )
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=1ad09d27dec679b004cc9e3dff6c2767&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        //1. create url and initialize it
        if let url = URL(string: urlString) {
            
            //2. create URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give URLSession a task
            //let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            //changing the above line to a swift closure
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
            
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(safeData){
                        //send data back to WeatherViewController to parse it in to UIViews
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. start the task
            task.resume()
        }
    }
    /*
    //this code has been changed into a closure
    //    func handle(data: Data?, response: URLResponse?, error: Error?) {
    //        if error != nil{
    //            print(error!)
    //            return
    //        }
    //
    //        if let saveData = data {
    //            let dataString = String(data: saveData, encoding: .utf8)
    //            print(dataString)
    //        }
    //    }*/
    
    
    //json data parser method
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        //create JSONDecoder  and initialize it
        let decoder = JSONDecoder()
        print(weatherData)
        //use decoder to decode json data return from the web
        do {
            //wrap in try catch block
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name

            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }catch{
            self.delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
}
