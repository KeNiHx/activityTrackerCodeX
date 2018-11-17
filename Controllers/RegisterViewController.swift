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
        view.frame.origin.y = -80
    }
    
    // Event for pressing Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            // When Return key is pressed, the focus goes to the next field
            textField.resignFirstResponder()
            txtEmailAddress.becomeFirstResponder()
        }
        if textField == txtEmailAddress {
            // When Return key is pressed, the focus goes to the next field
            textField.resignFirstResponder()
            txtPassword.becomeFirstResponder()
        }
        if textField == txtPassword {
            // When Return key is pressed, the focus goes to the next field
            textField.resignFirstResponder()
            txtConfirmPassword.becomeFirstResponder()
        }
        if textField == txtConfirmPassword {
            // When Return key is pressed while in password field, the frame goes back to normal and signs in the user
            textField.resignFirstResponder()
            view.frame.origin.y = 0
        }
        return true
    }
    
    private func setupUI() {
        // Adding delegates
        txtUsername.delegate = self
        txtEmailAddress.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
}
