//
//  WelcomeViewViewController.swift
//  The first controller that shows when opening the app for the first time.
//  This controller should hide when a user has already logged in before.
//
//  Created by Lee Palisoc on 2018-11-12.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    // OUTLETS
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    // MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addKeyboardListeners()
    }
    
    // MARK: Start listening for keyboard hide/show events
    private func addKeyboardListeners() {
        // Keyboard Listeners
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanges(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanges(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanges(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: Stop listening for keyboard hide/show events
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: Keyboard events
    // Frame goes up a little bit for small screens.
    @objc func keyboardChanges(notification: Notification) {
        view.frame.origin.y = -100
    }
    
    // Event for pressing Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            // When Return key is pressed, the focus goes to the next field
            textField.resignFirstResponder()
            txtPassword.becomeFirstResponder()
        }
        if textField == txtPassword {
            // When Return key is pressed while in password field, the frame goes back to normal and signs in the user
            textField.resignFirstResponder()
            txtPassword.resignFirstResponder()
            view.frame.origin.y = 0
            
            // Check user first if it exists or not
            checkUserExistence()
        }
        return true
    }
    
    // MARK: Listener for making sure password is more than 4 characters
    @IBAction func passwordEditingChanged(_ sender: UITextField) {
        if sender.text!.count >= 1 && sender.text!.count <= 4 {
            lblWarning.text = "Password is too short."
            btnContinue.isEnabled = false
        }
        else if sender.text!.isEmpty {
            lblWarning.text = ""
            btnContinue.isEnabled = false
        } else {
            lblWarning.text = ""
            btnContinue.isEnabled = true
        }
    }
    
    // MARK: Setting Up UI Design
    private func setupUI() {
        // Adding delegates
        txtUsername.delegate = self
        txtPassword.delegate = self
        
        // Helper for editing listener
        txtPassword.addTarget(self, action: #selector(passwordEditingChanged(_:)), for: UIControl.Event.editingChanged)
        
        // Designing the Continue button
        btnContinue.layer.shadowOpacity = 0.2
        btnContinue.layer.shadowOffset = CGSize(width: 1, height: 2)
        btnContinue.layer.shadowRadius = 15
    }
    
    // MARK: Checking user's account
    private func checkUserExistence() {
        
    }
}
