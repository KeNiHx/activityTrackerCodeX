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
    @IBOutlet weak var btnSignOut: UIButton!
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    // MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // TEST
    @IBAction func signOutTest(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Starting @var handle listener...")
        }
    }
    
    // viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
        print("Removing @var handle listener...")
    }
}
