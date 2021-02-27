//
//  Model.swift
//  TestAppWeather
//
//  Created by Максим Вечирко on 26.02.2021.
//

import Foundation

//{
//    "coord": {
//        "lon": 33.6292,
//        "lat": 34.9167
//    },
//    "weather": [
//        {
//            "id": 800,
//            "main": "Clear",
//            "description": "ясно",
//            "icon": "01n"
//        }
//    ],
//    "base": "stations",
//    "main": {
//        "temp": 10.35,
//        "feels_like": 7.7,
//        "temp_min": 9,
//        "temp_max": 11,
//        "pressure": 1020,
//        "humidity": 76
//    },
//    "visibility": 10000,
//    "wind": {
//        "speed": 2.57,
//        "deg": 300
//    },
//    "clouds": {
//        "all": 0
//    },
//    "dt": 1614373368,
//    "sys": {
//        "type": 1,
//        "id": 6372,
//        "country": "CY",
//        "sunrise": 1614313134,
//        "sunset": 1614353893
//    },
//    "timezone": 7200,
//    "id": 146400,
//    "name": "Ларнака",
//    "cod": 200
//}


struct Model: Decodable {
    var weather: [Weather]
    var main: Main
    var wind: Wind
    var clouds: Clouds
    var name: String
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Codable {
    var temp: Double
    var pressure: Int
    var humidity: Int
}

struct Wind: Codable {
    var speed: Double
    var deg: Int
}

struct Clouds: Codable {
    var all: Int
}















