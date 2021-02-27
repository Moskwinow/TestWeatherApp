//
//  RequestFactory.swift
//  Shop
//
//  Created by Максим Вечирко on 20.12.2020.
//  Copyright © 2020 Максим Вечирко. All rights reserved.
//

import Alamofire

class RequestFactory {
    
    func makeErrorParser() -> AbstractErrorParser {
        ErrorParser()
    }
    
    lazy var commonSession: Session = {
        let config = URLSessionConfiguration.default
        config.httpShouldSetCookies = false
        config.headers = .default
        let manager = Session(configuration: config)
        return manager
    }()
    
    let sessionQueue = DispatchQueue.global(qos: .utility)
    
    func makeWeatherRequestFactory() -> WeatherRequestFactory {
        let errorParser = makeErrorParser()
        return WeatherRequest(errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }
}
