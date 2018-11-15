//
//  User.swift
//  Structure for setting up a user.
//  Values are defaulted to Metric values.
//
//  Created by Lee Palisoc on 2018-11-12.
//  Copyright © 2018 CodeX. All rights reserved.
//

import Foundation
import UIKit

struct User {
    
    var lastName: String = ""
    var firstName: String = ""
    var gender: Character? = nil
    var weight: Double? = nil
    var height: Double? = nil
    var profilePic: UIImage? = nil
    var birthday: Date? = nil
    
    // MARK: Setters
    mutating func setGender(sex: Character) {
        self.gender = sex
    }
    
    mutating func setBirthday(birthday: Date) {
        self.birthday = birthday
    }
    
    mutating func setWeight(weight: Double) {
        self.weight = weight
    }
    
    mutating func setHeight(height: Double) {
        self.height = height
    }
    
    mutating func setProfilePic(photo: UIImage) {
        self.profilePic = photo
    }
    
    // MARK: Height conversion to Imperial
    // Source: https://www.albireo.ch/imperialconverter/formula.html
    func getHeightInImperial(height: Int) -> String {
        let feet = Double(height) / 30.48
        let inches = Double(height) / 2.54
        
        let floor = Int(feet) * 12
        let remInches = (Int(inches) - floor)
        
        return "\(Int(feet))'\(remInches)\""
    }
    
    // MARK: Height conversion to Metric
    // Source: https://www.albireo.ch/imperialconverter/formula.html
    func getHeightInMetric(feet: Int, inches: Int) -> Int {
        let f = Double(feet) * 30.48
        let i = Double(inches) * 2.54
        
        return Int(f+i)
    }
    
    // MARK: Weight conversion to Imperial
    // Source: https://www.albireo.ch/imperialconverter/formula.html
    func getWeightInImperial(weight: Double) -> Double {
        let kg = weight * 0.45359
        
        return kg.roundToPlaces(places: 1)
    }
    
    // MARK: Weight conversion to Metric
    // Source: https://www.albireo.ch/imperialconverter/formula.html
    func getWeightInMetric(weight: Double) -> Double {
        let lbs = weight * 2.2046
        
        return lbs.roundToPlaces(places: 0)
    }
}

// MARK: Function for getting two decimal places without converting the Double value to a String
// Source: https://danilovdev.blogspot.com/2016/10/rounding-double-value-to-n-number-of.html

extension Double {
    // Rounding the Double value to places: decimal points
    func roundToPlaces(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
