//
//  TodayViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-19.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import Firebase

class TodayViewController: UIViewController {

    /**
        @IBOutlets
        @brief Outlets needed for the view controller.
     */
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    // MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Function for setting up the UI
    private func setupUI() {
        // Getting today's date
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        
        lblDate.text = formatter.string(from: currentDate).uppercased()
        
        // Formatting the UIImageView for Profile Pic
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height/2
        imgProfilePic.layer.shadowOpacity = 0.3
        imgProfilePic.layer.shadowOffset = CGSize(width: 1, height: 1)
        imgProfilePic.layer.shadowRadius = 3
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Today View: Starting @var handle listener...")
        }
    }
    
    // viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
        print("Today View: Removing @var handle listener...")
    }
}
