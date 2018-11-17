//
//  RegisterViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-16.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
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
    
    // MARK: Keyboard events
    
    // Event for pressing Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            // When Return key is pressed, the focus goes to the next field
            txtEmailAddress.becomeFirstResponder()
        }
        if textField == txtEmailAddress {
            // When Return key is pressed, the focus goes to the next field
            txtPassword.becomeFirstResponder()
        }
        if textField == txtPassword {
            // When Return key is pressed, the focus goes to the next field
            txtConfirmPassword.becomeFirstResponder()
        }
        if textField == txtConfirmPassword {
            // When Return key is pressed while in password field, keyboard will hide.
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: Functions for moving the frame when keyboard shows/hides
    // Showing keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 150
        }
    }
    
    // Hiding keyboard
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: Setting up Delegates, Tap Gestures
    private func setupUI() {
        // Adding delegates
        txtUsername.delegate = self
        txtEmailAddress.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        
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
        self.txtEmailAddress.inputAccessoryView = toolbar
        self.txtPassword.inputAccessoryView = toolbar
        self.txtConfirmPassword.inputAccessoryView = toolbar
    }
    
    // MARK: Action for "Done" button on the keyboard.
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
}
