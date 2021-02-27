//
//  ViewModel.swift
//  TestAppWeather
//
//  Created by Максим Вечирко on 26.02.2021.
//

import Bond
import CoreLocation

enum UnitSymbol: String {
    case C = "°"
    case F = "°F"
}

protocol ViewModel {
    var temperature: Observable<String> {get set}
    var wind: Observable<String> {get set}
    var humidity: Observable<String> {get set}
    var probablyRain: Observable<String> {get set}
    var pressure: Observable<String> {get set}
    var city: Observable<String> {get set}
    
    var weatherImageName: String {get set}
    var weatherImageNameChanged: (() -> ())? {get set}
    
    func fetchWeatherData(unit: Units, symbol: UnitSymbol)
    func requestUserLocation()
    func updateLocation()
    
    func handleCoordinatesByCityName(name: String)
    
}

class ViewModelImpl: NSObject, ViewModel {

    private var requestFactory: RequestFactory
    private var locationManager: CLLocationManager
    private var geocoder: CLGeocoder
    private var lat: Double = 0.0
    private var lon: Double = 0.0
    
    var temperature = Observable<String>("")
    var wind = Observable<String>("")
    var humidity = Observable<String>("")
    var probablyRain = Observable<String>("")
    var pressure = Observable<String>("")
    var city = Observable<String>("")
    
    var weatherImageName: String = "" {
        didSet {
            weatherImageNameChanged?()
        }
    }
    var weatherImageNameChanged: (() -> ())?
    
    init(locationManager: CLLocationManager, geocoder: CLGeocoder) {
        self.requestFactory = RequestFactory()
        self.locationManager = locationManager
        self.geocoder = geocoder
        super.init()
        
    }
    
    func fetchWeatherData(unit: Units, symbol: UnitSymbol) {
        
        let request = requestFactory.makeWeatherRequestFactory()
        
        request.loadData(lat: lat, lon: lon, units: unit) { [weak self] (response) in
            guard let self = self else {return}
            switch response.result {
            case .success(let model):
                self.temperature.value = "\(Int(model.main.temp))\(symbol.rawValue)"
                self.wind.value = "\(model.wind.speed) м/с"
                self.humidity.value = "\(model.main.humidity)%"
                self.probablyRain.value = "\(model.clouds.all)%"
                self.pressure.value = "\(model.main.pressure) мм рт.ст"
                self.city.value = model.name
                self.weatherImageName = "\(model.weather.first?.icon ?? "")"
                self.locationManager.stopUpdatingLocation()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func requestUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateLocation() {
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        self.fetchWeatherData(unit: .metric, symbol: .C)
    }
    
  private func handleUserCity(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (place, error) in
            if error == nil {
                if let locality =  place?.first?.locality {
                    print(locality)
                }
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    
    func handleCoordinatesByCityName(name: String) {
        geocoder.geocodeAddressString(name) { [weak self] (placemarks, error) in
            guard let self = self else {return}
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                guard let coordinate = placemarks?.first?.location?.coordinate else {return}
                self.lat = coordinate.latitude
                self.lon = coordinate.longitude
                self.fetchWeatherData(unit: .metric, symbol: .C)
            }
        }
    }
    
}

extension ViewModelImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print(location)
            self.lat = location.coordinate.latitude
            self.lon = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
