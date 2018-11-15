//
//  WelcomeViewViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-12.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Setting Up UI Design
    private func setupUI() {
        // Sign In Button
        btnSignIn.layer.shadowOpacity = 0.2
        btnSignIn.layer.shadowOffset = CGSize(width: 1, height: 2)
        btnSignIn.layer.shadowRadius = 15
        
        // Register Button
        btnRegister.layer.shadowOpacity = 0.2
        btnRegister.layer.shadowOffset = CGSize(width: 1, height: 2)
        btnRegister.layer.shadowRadius = 15
    }
    
}
