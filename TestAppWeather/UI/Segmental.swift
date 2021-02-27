//
//  Segmental.swift
//  TestAppWeather
//
//  Created by Максим Вечирко on 27.02.2021.
//

import UIKit

class Segmental: UISegmentedControl {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configurateSegmentalControl()
    }
    
    private  func configurateSegmentalControl() {
        guard let font = UIFont.init(name: "Lato-Regular", size: 17) else {return}
        let colorNormal: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let fontAttributeNormal = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: colorNormal] as [NSAttributedString.Key : Any]
        let colorSelected: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        let fontAttributeSelected = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: colorSelected] as [NSAttributedString.Key : Any]
        
        setTitleTextAttributes(fontAttributeNormal, for: .normal)
        setTitleTextAttributes(fontAttributeSelected, for: .selected)
        
    }
}
