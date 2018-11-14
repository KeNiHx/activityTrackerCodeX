//
//  User.swift
//  Structure for setting up a user.
//
//  Created by Lee Palisoc on 2018-11-12.
//  Copyright © 2018 CodeX. All rights reserved.
//

import Foundation

struct User {
    var lastName: String = ""
    var firstName: String = ""
    var birthday = Date()
    var gender: Character? = nil
    var weight: Double? = nil
    var height: Double? = nil
    
    mutating func setGender(sex: Character) {
        self.gender = sex
    }
    
    mutating func setWeight(weight: Double) {
        self.weight = weight
    }
    
    mutating func setHeight(height: Double) {
        self.height = height
    }
}
