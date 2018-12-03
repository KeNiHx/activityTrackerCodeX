//
//  WorkoutButtonsViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-23.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit

class WorkoutButtonsViewController: UIViewController {
    
    /**
     @IBOutlets
     @brief IBOutlets needed for the view controller
    */
    @IBOutlet weak var btnIndoorRunning: UIButton!
    @IBOutlet weak var btnOutdoorRunning: UIButton!
    @IBOutlet weak var btnIndoorWalking: UIButton!
    @IBOutlet weak var btnOutdoorWalking: UIButton!
    @IBOutlet weak var btnIndoorCycling: UIButton!
    @IBOutlet weak var btnOutdoorCycling: UIButton!
    private let outdoor = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorkoutOutdoorBoardID") as! WorkoutOutdoorSessionViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startIndoorRunning(_ sender: UIButton) {
        
    }
    
    @IBAction func startOutdoorRunning(_ sender: UIButton) {
        outdoor.chosenWorkout = WorkoutType.outdoorRunning
        outdoor.color = UIColor(red:0.60, green:0.80, blue:0.83, alpha: 1.0)
        showOutdoorSessionController(viewController: outdoor)
    }
    
    @IBAction func startIndoorWalking(_ sender: UIButton) {
    }
    
    @IBAction func startOutdoorWalking(_ sender: UIButton) {
        outdoor.chosenWorkout = WorkoutType.outdoorWalking
        outdoor.color = UIColor(red: 0.54, green: 0.74, blue: 0.66, alpha: 1.0)
        showOutdoorSessionController(viewController: outdoor)
    }
    
    @IBAction func startIndoorCycling(_ sender: UIButton) {
        
    }
    
    @IBAction func startOutdoorCycling(_ sender: UIButton) {
        outdoor.chosenWorkout = WorkoutType.outdoorCycling
        outdoor.color = UIColor(red: 0.44, green: 0.68, blue: 0.44, alpha: 1.0)
        showOutdoorSessionController(viewController: outdoor)
    }
    
    private func showOutdoorSessionController(viewController: UIViewController) {
        self.dismiss(animated: true, completion: nil)
        self.present(viewController, animated: true, completion: nil)
    }
}
