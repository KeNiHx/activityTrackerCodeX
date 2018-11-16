//
//  Workout.swift
//  Constructor for a workout.
//
//  Created by Lee Palisoc on 2018-11-15.
//  Copyright © 2018 CodeX. All rights reserved.
//

import Foundation

struct Workout {
    
    var type: WorkoutType
    var totalTime: TimeInterval
    var totalDistance: Double
    var sessionDate: Date
    var averagePace: String
    var totalCalories: Double
    
    // Optionals
    var timeGoal: TimeInterval? = nil
    var distanceGoal: Double? = nil
}

// MARK: Workout types available
enum WorkoutType {
    case indoorRunning, indoorWalking, indoorCycling, outdoorRunning, outdoorWalking, outdoorCycling
}


