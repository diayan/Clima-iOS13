//
//  WeatherData.swift
//  Clima
//
//  Created by diayan siat on 25/07/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//enable the struct to be decodable and encodable using Codable 
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: Array<Weather>
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
