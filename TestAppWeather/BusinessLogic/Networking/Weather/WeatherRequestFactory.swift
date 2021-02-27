//
//  WeatherRequestFactory.swift
//  TestAppWeather
//
//  Created by Максим Вечирко on 26.02.2021.
//

import Alamofire

enum Units: String {
    case metric
    case imperial
}

protocol WeatherRequestFactory {
    func loadData(lat: Double, lon: Double, units: Units, completionHandler: @escaping(AFDataResponse<Model>) -> ())
}
