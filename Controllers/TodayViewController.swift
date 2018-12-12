//
//  TodayViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-19.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class TodayViewController: UIViewController {

    /**
        @IBOutlets
        @brief Outlets needed for the view controller.
     */
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblRandomMessage: UILabel!
    
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var imgThisWeek: UIImageView!
    
    
    /**
     @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    /**
     @var ref
     @brief Creates a reference to the Firebase Database
     */
    var ref: DatabaseReference?
    
    /**
     @var messages
     @let random
     @brief Random messages that will appear evertime the view controller opens, chosen by the random() function.
     */
    var messages = ["what do you want to do today?", "do you want to start a workout right away?", "feeling pumped? let's workout!"]
    let random = Int.random(in: 0..<3)
    
    // MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ref = Database.database().reference()
        
        imgActivity.layer.shadowOpacity = 0.3
        imgActivity.layer.shadowOffset = CGSize(width: 1, height: 2)
        imgActivity.layer.shadowRadius = 15
        
        imgThisWeek.layer.shadowOpacity = 0.3
        imgThisWeek.layer.shadowOffset = CGSize(width: 1, height: 2)
        imgThisWeek.layer.shadowRadius = 15
    }
    
    // MARK: Function for setting up the UI
    private func setupUI() {
        // Getting today's date
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        
        lblDate.text = formatter.string(from: currentDate).uppercased()
        
        // Retrieve the user's profile pic
        getProfilePhoto()
        
        // Formatting the UIImageView for Profile Pic
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height/2
        imgProfilePic.layer.shadowOpacity = 0.2
        imgProfilePic.layer.shadowOffset = CGSize(width: 1, height: 1)
        imgProfilePic.layer.shadowRadius = 2
        
        // Setting the random message
        lblRandomMessage.text = messages[random]
    }
    
    // MARK: - Retrieving user's profile photo from Firebase
    private func getProfilePhoto() {
        
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
