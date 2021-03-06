//
//  RegisterViewController.swift
//  View controller for signing up users.
//
//  Created by Lee Palisoc on 2018-11-16.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift
import FirebaseDatabase
import FirebaseAuth
import DSLoadable

class RegisterViewController: UIViewController, UITextFieldDelegate {

    /**
     @IBOutlets
     @brief Outlets needed for the view controller.
     */
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblWarning: UILabel!
    
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
        ref = Database.database().reference()
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
            btnSignUp.isEnabled = false
            btnSignUp.alpha = 0.5
        } else {
            lblWarning.text = ""
        }
    }
    
    // MARK: Listener for making sure passwords match
    @IBAction func passwordMatches(_ sender: UITextField) {
        if sender.text != self.txtPassword.text {
            lblWarning.text = "Passwords don't match."
            btnSignUp.isEnabled = false
            btnSignUp.alpha = 0.5
        } else {
            lblWarning.text = ""
            btnSignUp.isEnabled = true
            btnSignUp.alpha = 1.0
        }
    }
    
    // MARK: Action for the Continue button
    @IBAction func registerUser(_ sender: Any?) {
        createUser(email: txtEmailAddress.text!, password:txtPassword.text!)
        
//        let registerPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdditionalInfoPageViewController") as! RegisterPageViewController
//
//        self.present(registerPageViewController, animated: true, completion: nil)
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
        
        // Sizing the description label
        lblSubtitle.numberOfLines = 0
        lblSubtitle.sizeToFit()
        
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
        
        // Disabling the Continue button
        btnSignUp.isEnabled = false
        btnSignUp.cornerRadius = 18.5
        
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
        // Setting the loading indicator
        btnSignUp.setTitle("", for: .normal)
        btnSignUp.loadableStartLoading()
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                        case .emailAlreadyInUse:
                            self.lblWarning.text = """
                            Email is already in use.
                            Please choose a different one.
                            """
                        case .networkError:
                            self.lblWarning.text = """
                            There was a network error.
                            Try pressing Continue again.
                            """
                        case .invalidEmail:
                            self.lblWarning.text = "The email format is invalid."
                        default:
                            print(error.debugDescription)
                            self.lblWarning.text = "Something went wrong. Try again."
                    }
                    
                    // Something went wrong, stop the loading indicator
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.btnSignUp.loadableStopLoading()
                    }
                }
            }
            // Send a user an email verification email and display the verify email view
            else {
                
                // Store the mail into the Firebase Database
                if let user = Auth.auth().currentUser {
                    self.ref?.child("users").child(user.uid).child("info").setValue(["email" : self.txtEmailAddress.text!])
                }
                
                let actionCodeSettings = ActionCodeSettings.init()
                actionCodeSettings.handleCodeInApp = true
                let user = Auth.auth().currentUser
                actionCodeSettings.url = NSURL(string: "https://www.movebycodex.ca/verify?email=\(user!.email!)")! as URL
                actionCodeSettings.setIOSBundleID((Bundle.main.bundleIdentifier)!)
               
                user?.sendEmailVerification(with: actionCodeSettings, completion: { error in
                    // If there is an error, put an error message and ask the user to try again
                    // Otherwise, show the "Almost Done" view controller to let the user know that s/he needs to verify his/her email address
                    if error != nil {
                        let banner = GrowingNotificationBanner(title: "Error", subtitle: "There was an internal error. Please try again.", style: .danger)
                        banner.show()
                        return
                    } else {
                        
                        // User has successfully been created, stop the indicator
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.btnSignUp.loadableStopLoading()
                        }
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequiredInfo2BoardID") as! RegisterRequiredInfoViewController
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                })
            }
            
            guard (authResult?.user) != nil else {
                return
            }
        }
    }
    
    
    
}
