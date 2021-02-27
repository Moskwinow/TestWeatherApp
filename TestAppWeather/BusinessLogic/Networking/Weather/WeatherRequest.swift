//
//  WeatherRequest.swift
//  TestAppWeather
//
//  Created by Максим Вечирко on 26.02.2021.
//

import Alamofire

class WeatherRequest: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    
    var sessionManager: Session
    
    var queue: DispatchQueue
    
    private let baseUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather")!
    
    init(errorParser: AbstractErrorParser, sessionManager: Session, queue: DispatchQueue) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
    

}

extension WeatherRequest: WeatherRequestFactory {
    func loadData(lat: Double, lon: Double, units: Units, completionHandler: @escaping (AFDataResponse<Model>) -> ()) {
        let requestModel = WeatherRequestModel(baseUrl: baseUrl, lat: lat, lon: lon, units: units)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
}

extension WeatherRequest {
    struct WeatherRequestModel: RequestRouter {
        var baseUrl: URL
        
        var method: HTTPMethod = .get
        
        var path: String {
            ""
        }
        
        var lat: Double
        var lon: Double
        
        var units: Units 
        
        private var lang: String {
            "ru"
        }
        private var appid: String {
            "e78dde069c41bca503385dcf93a3278a"
        }
        
        var parameters: Parameters? {
            return [
                "lat": lat,
                "lon": lon,
                "lang": lang,
                "appid": appid,
                "units": units
            ]
        }
        
        
    }
}
