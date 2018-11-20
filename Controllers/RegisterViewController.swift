//
//  RegisterViewController.swift
//  View controller for signing up users.
//
//  Created by Lee Palisoc on 2018-11-16.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    /**
     @IBOutlets
     @brief Outlets needed for the view controller.
     */
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblWarning: UILabel!
    
    /**
     @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    /**
     @var passedEmail
     @var passedDescription
     @brief variables for getting the passed email (so the user don't need to retype it when asked to sign up) and passed description (for informing the user that the account hasn't signed up yet) from the signin page.
     @optionals since it's the same view controller when the system detects the account is not in the system yet, or when the user taps on "Sign up for an account" button
     */
    var passedEmail: String? = nil
    var passedPassword: String? = nil
    var passedDescription: String? = nil
    
    // MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addKeyboardListeners()
    }
    
    // MARK: Changing the status bar's style to colour white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
            
            // Label for letting the user know that the account is being created.
            lblWarning.text = "Creating account..."
            
            // When Return key is pressed, create the user
            createUser(email: txtEmailAddress.text!, password: txtPassword.text!)
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
    
    // MARK: Listener for making sure password is not too short
    @IBAction func shortPassword(_ sender: UITextField) {
        if sender.text!.count >= 1 && sender.text!.count <= 4 {
            lblWarning.text = "Password is too short."
            btnContinue.isEnabled = false
        } else {
            lblWarning.text = ""
        }
    }
    
    // MARK: Listener for making sure passwords match
    @IBAction func passwordMatches(_ sender: UITextField) {
        if sender.text != self.txtPassword.text {
            lblWarning.text = "Passwords don't match."
            btnContinue.isEnabled = false
        } else {
            lblWarning.text = ""
            btnContinue.isEnabled = true
        }
    }
    
    // MARK: Action for the Continue button
    @IBAction func registerUser(_ sender: Any?) {
        print("TEST: REGISTERING...")
        
        let registerPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdditionalInfoPageViewController") as! RegisterPageViewController
        
        self.present(registerPageViewController, animated: true, completion: nil)
    }
    
    // MARK: Setting up Delegates, Tap Gestures
    private func setupUI() {
        // Adding delegates
        txtEmailAddress.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        
        // Adding helper for editing listener
        txtPassword.addTarget(self, action: #selector(shortPassword(_:)), for: UIControl.Event.editingChanged)
        txtConfirmPassword.addTarget(self, action: #selector(passwordMatches(_:)), for: UIControl.Event.editingChanged)
        
        // Setting the passed email address and passed description from sign in view controller
        if (passedEmail != nil) {
            txtEmailAddress.text = passedEmail
        }
        if (passedPassword != nil) {
            txtPassword.text = passedPassword
        }
        if (passedDescription != nil) {
            lblSubtitle.text = passedDescription
        }
        
        // Designing the Continue button
        btnContinue.layer.shadowOpacity = 0.2
        btnContinue.layer.shadowOffset = CGSize(width: 1, height: 2)
        btnContinue.layer.shadowRadius = 15
        
        btnCancel.layer.shadowOpacity = 0.2
        btnCancel.layer.shadowOffset = CGSize(width: 1, height: 2)
        btnCancel.layer.shadowRadius = 15
        
        // Sizing the description label
        lblSubtitle.numberOfLines = 0
        lblSubtitle.sizeToFit()
        
        // Disabling the Continue button
        btnContinue.isEnabled = false
        
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
        self.txtEmailAddress.inputAccessoryView = toolbar
        self.txtPassword.inputAccessoryView = toolbar
        self.txtConfirmPassword.inputAccessoryView = toolbar
    }
    
    // MARK: Action for "Done" button on the keyboard.
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    // MARK: Action for Cancel button
    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // FIREBASE
    
    // MARK: Adding Firebase's Authentications
    // The controller's viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    
    // The controller's viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: Function for creating the user
    private func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        self.lblWarning.text = "Email is already in use. Please choose a different one."
                    case .networkError:
                        self.lblWarning.text = "There was a network error. Try pressing Continue again."
                    default:
                        self.lblWarning.text = "Something went wrong. Try again."
                    }
                }
            }
            
            guard let user = authResult?.user else { return }
            
            
        }
    }
}
