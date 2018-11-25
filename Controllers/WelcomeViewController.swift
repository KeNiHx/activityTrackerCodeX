//
//  WelcomeViewViewController.swift
//  The first controller that shows when opening the app for the first time.
//  This controller should hide when a user has already logged in before.
//
//  Created by Lee Palisoc on 2018-11-12.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import Firebase
import DSLoadable

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    /** @IBOutlets
        @brief Outlets in the view controller
     */
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    /** @var handle
        @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Changing the status bar's style to colour white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Start listening for keyboard hide/show events
    private func addKeyboardListeners() {
        // Keyboard Listeners
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Stop listening for keyboard hide/show events
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Event for pressing Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            // When Return key is pressed, the focus goes to the next field
            txtPassword.becomeFirstResponder()
        }
        if textField == txtPassword {
            // When Return key is pressed while in password field, the frame goes back to normal and signs in the user
            txtPassword.resignFirstResponder()
            
            // Label to let the user know s/he is being signed in.
            lblWarning.text = "Logging in..."
            
            // Check user first if it exists or not
            checkUserExistence(email: txtEmail.text!, password: txtPassword.text!)
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
    
    // MARK: - Listener for making sure password is more than 4 characters
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
    
    // MARK: - Setting Up UI, Adding Delegates, Tap Gestures
    private func setupUI() {
        // Adding delegates
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        // Helper for editing listener
        txtPassword.addTarget(self, action: #selector(passwordEditingChanged(_:)), for: UIControl.Event.editingChanged)
        
        // Make sure Continue button is disabled
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
        lblWarning.sizeToFit()
        
        // Setting the toolbar as inputAccessoryView for every element that needs it
        self.txtEmail.inputAccessoryView = toolbar
        self.txtPassword.inputAccessoryView = toolbar
    }
    
    // MARK: - Action for "Done" button on the keyboard.
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    // FIREBASE
    // MARK: - Checking user account's existence
    private func checkUserExistence(email: String, password: String) {
        // Label for the action
        lblWarning.text = "Logging in..."
        
        // Set the loading indicator on the Continue button
        btnContinue.setTitle("", for: .normal)
        btnContinue.loadableStartLoading()
        
        // Actually check for the user—-Haha!
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                // If error exists, remove the loading indicator, and put the "Continue" text back to the button
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.btnContinue.loadableStopLoading()
                }
                self.btnContinue.setTitle("Continue", for: .normal)
                
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    // Sets the warning label when the user entered the wrong password.
                    case .wrongPassword:
                        self.lblWarning.text = "You entered the wrong password. Try again."
                        
                    // Sets the warning label when the user entered an invalid email format.
                    case .invalidEmail:
                        self.lblWarning.text = "You entered an invalid email. Try again."
                        
                    // If user is not found, the register view controller automatically shows up, getting the email address the user typed, and entering it on the email address text field on the register view controller.
                    case .userNotFound:
                        let registerView = self.storyboard?.instantiateViewController(withIdentifier: "RegisterBoardID") as! RegisterViewController
                        
                        registerView.passedDescription = """
                        Hello, \(self.txtEmail.text!)! We noticed that you don't have an account yet.
                        
                        Just re-enter your password again and press Continue.
                        """
                        
                        registerView.passedEmail = self.txtEmail.text!
                        registerView.passedPassword = self.txtPassword.text!
                        
                        self.present(registerView, animated: true, completion: nil)
                        
                    // Default when something (we're not sure of) went wrong
                    default:
                        print(error.debugDescription)
                        self.lblWarning.text = "Something went wrong. Try again."
                    }
                }
            } else {
                self.checkValidation()
            }
        }
    }
    
    // MARK: - Action for signing in user
    @IBAction func btnSignIn(_ sender: UIButton) {
        // Check if the user exists
        checkUserExistence(email: txtEmail.text!, password: txtPassword.text!)
    }
    
    // MARK: - Check user's validation (NOT JUST ITS EXISTENCE!)
    private func checkValidation() {
        // If the user has already signed in and has a verified email address, skip this view controller and show TodayViewController
        // Otherwise, still show this controller, put the user's email address on the field, and tell the user that s/he needs to verify it first.
        if Auth.auth().currentUser != nil {
            
            // !!! DISABLING EMAIL VERIFICATION BLOCKING FOR NOW !!!
            
            //if (Auth.auth().currentUser?.isEmailVerified)! {
            //} else {
            //    self.setupUI()
            //    s elf.addKeyboardListeners()
            //    self.txtEmail.text = Auth.auth().currentUser?.email
            //    self.lblWarning.text = """
            //    Your email address needs to be verified.
            //    Check your inbox for the link.
            //    """
            //}
            
            let todayView = self.storyboard?.instantiateViewController(withIdentifier: "TodayViewBoardID") as! TodayViewController
                self.dismiss(animated: true, completion: nil)
                self.present(todayView, animated: true, completion: nil)
        }
        // Otherwise, show the login page
        else {
            self.setupUI()
            self.addKeyboardListeners()
        }
    }
    
    // MARK: - Functions for overriding functions in this view controller
    // The controller's viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Starting @var handle listener...")
            self.checkValidation()
        }
    }
    
    // The controller's viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
        print("Removing @var handle listener...")
        
        // Resetting the fields
        self.lblWarning.text = ""
        self.txtEmail.text = ""
        self.txtPassword.text = ""
    }
}

// MARK: - Extension for adding designs on the UI Images
@IBDesignable extension UIButton {
    @IBInspectable
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor { return UIColor(cgColor: color) }
            return nil
        }
        set {
            if let color = newValue { layer.shadowColor = color.cgColor }
            else { layer.shadowColor = nil }
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
