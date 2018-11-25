//
//  RegisterRequiredInfoViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-22.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit

class RegisterRequiredInfoViewController: UIViewController {

    /**
     @IBOutlets
     @brief Outlets needed for the view controller.
     */
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    /**
     @var selectedGender
     @brief Temporary variable to know what gender is selected.
     */
    var selectedGender: String? = nil
    
    // MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Function for the Next button's action
    @IBAction func nextPage(_ sender: UIButton) {
        
    }
    
    // MARK: - Functions for selecting gender
    // When selecting a gender, it should put its alpha to 100% (1.0) to let the user know that it is the correct choice—-50% (0.5) for the unselected choice.
    
    // Male Action
    @IBAction func selectedMale(_ sender: UIButton) {
        // "Selecting" the Male button
        selectedGender = "Male"
        btnMale.alpha = 1.0
        btnMale.layer.shadowOpacity = 0.2
        
        // "Deselecting" the Female button
        btnFemale.alpha = 0.5
        btnFemale.layer.shadowOpacity = 0
    }
    
    // Female Action
    @IBAction func selectedFemale(_ sender: UIButton) {
        // "Selecting" the Female button
        selectedGender = "Female"
        btnFemale.alpha = 1.0
        btnFemale.layer.shadowOpacity = 0.2
        
        // "Deselecting" the Male button
        btnMale.alpha = 0.5
        btnMale.layer.shadowOpacity = 0
    }
    
    // MARK: - Function for setting up the controller's UI
    private func setupUI() {
        
    }
    
    // MARK: Overriding viewWillAppear and viewWillDisappear functions
    // Controller's viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // Controller's viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}
