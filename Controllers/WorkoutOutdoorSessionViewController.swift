//
//  WorkoutOutdoorSessionViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-25.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit

class WorkoutOutdoorSessionViewController: UIViewController {

    /**
     @IBOutlets
     @brief Outlets needed for this current controller.
     */
    @IBOutlet weak var lblWorkoutType: UILabel!
    @IBOutlet weak var btnStartWorkout: UIButton!
    @IBOutlet weak var viewWorkoutDetails: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Function for setting up the UI
    private func setupUI() {
        // Adding shadows on the floating views
        viewWorkoutDetails.layer.shadowOpacity = 0.5
        viewWorkoutDetails.layer.shadowRadius = 20
        viewWorkoutDetails.layer.shadowOffset = CGSize(width: 1, height: 2)
        viewWorkoutDetails.layer.cornerRadius = 8
    
        lblWorkoutType.layer.shadowRadius = 8
        lblWorkoutType.layer.shadowOpacity = 0.3
        lblWorkoutType.layer.shadowOffset = CGSize(width: 1, height: 2)
    }
}
