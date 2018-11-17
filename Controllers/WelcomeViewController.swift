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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Stop listening for keyboard hide/show events
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Event for pressing Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            // When Return key is pressed, the focus goes to the next field
            txtPassword.becomeFirstResponder()
        }
        if textField == txtPassword {
            // When Return key is pressed while in password field, the frame goes back to normal and signs in the user
            txtPassword.resignFirstResponder()
            
            // Check user first if it exists or not
            checkUserExistence()
        }
        return true
    }
    
    // MARK: Functions for moving the frame when keyboard shows/hides
    // Showing keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
        }
    }
    
    // Hiding keyboard
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
    
    // MARK: Setting Up UI, Adding Delegates, Tap Gestures
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
        
        // Tap Gesture: For when the user taps outside the keyboard, the keyboard dismisses
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // Adding "Done" button on the keyboard
        // init the toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        
        // create empty space on the left side so that "done" button is set on the right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // init the "Done" button with its name and action
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(WelcomeViewController.doneButtonAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        // Setting the toolbar as inputAccessoryView for every element that needs it
        self.txtUsername.inputAccessoryView = toolbar
        self.txtPassword.inputAccessoryView = toolbar
    }
    
    // MARK: Action for "Done" button on the keyboard.
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    // MARK: Checking user's account
    private func checkUserExistence() {
        
    }
}
