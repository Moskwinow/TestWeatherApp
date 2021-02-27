//
//  ViewController.swift
//  TestAppWeather
//
//  Created by Максим Вечирко on 26.02.2021.
//

import UIKit
import Kingfisher
import Bond
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var segmental: Segmental!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    
    @IBOutlet weak var chooiceCity: UILabel!
    @IBOutlet weak var myLocationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var probablyRainLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!

    var viewModel: ViewModel?
    
    override func loadView() {
        super.loadView()
        self.viewModel = ViewModelImpl(locationManager: CLLocationManager(), geocoder: CLGeocoder())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurateProperties()
        self.configurateTextFieldView()
        self.configurateSelectors()
        
        self.viewModel?.requestUserLocation()
        self.viewModel?.fetchWeatherData(unit: .metric, symbol: .C)
        
    }
    
//    MARK: Private functions
    
    private func configurateProperties() {
        viewModel?.temperature.bind(to: temperatureLabel)
        viewModel?.humidity.bind(to: humidityLabel)
        viewModel?.pressure.bind(to: pressureLabel)
        viewModel?.probablyRain.bind(to: probablyRainLabel)
        viewModel?.wind.bind(to: windLabel)
        viewModel?.city.bind(to: cityName)
        
        viewModel?.weatherImageNameChanged = { [unowned self] in
            DispatchQueue.main.async {
                guard let imageName = self.viewModel?.weatherImageName else {return}
                self.weatherImage.kf.indicatorType = .activity
                self.weatherImage.kf.setImage(with: URL(string: "http://openweathermap.org/img/wn/\(imageName).png"))
            }
        }
    }
    
    private func configurateTextFieldView() {
        self.textFieldView.isHidden = true
    }
    
    private func configurateSelectors() {
        let gestureCity = UITapGestureRecognizer(target: self, action: #selector(showTextFieldView))
        self.chooiceCity.addGestureRecognizer(gestureCity)
        self.chooiceCity.isUserInteractionEnabled = true
        
        let gestureLocation = UITapGestureRecognizer(target: self, action: #selector(myLocation))
        self.myLocationLabel.addGestureRecognizer(gestureLocation)
        self.myLocationLabel.isUserInteractionEnabled = true
    }
    
//    MARK: Actions
    
    @IBAction func okButton(sender: UIButton) {
        guard let name = textField.text else {
            return
        }
        self.textFieldView.isHidden = true
        self.viewModel?.handleCoordinatesByCityName(name: name)
    }
    
    @IBAction func changeUnits(_ sender: Segmental) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel?.fetchWeatherData(unit: .metric, symbol: .C)
        case 1:
            viewModel?.fetchWeatherData(unit: .imperial, symbol: .F)
        default:
            break
        }
    }
    
//    MARK: Selectors
    
    @objc func showTextFieldView() {
        UIView.animate(withDuration: 0.5) {
            self.textFieldView.isHidden = false
        }
    }
    
    @objc func myLocation() {
        self.viewModel?.updateLocation()
    }
    
}

