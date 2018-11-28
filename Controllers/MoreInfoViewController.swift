//
//  MoreInfoViewController.swift
//  Move
//
//  Created by Kenny Lam on 2018-11-26.
//  Copyright © 2018 CodeX. All rights reserved.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth

class MoreInfoViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addKeyboardListeners()
        ref = Database.database().reference()
        
        
    }
    
    /**
     @var ref
     @brief Creates a reference to the Firebase Database
     */
    var ref: DatabaseReference?
    
    /**
     @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    // MARK: Chaning the status bar's style to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Function for setting up the controller's UI
    private func setupUI() {
        txtAge.delegate = self
        txtHeight.delegate = self
        txtWeight.delegate = self
        
        // Tap Gesture: For when the user taps outside the keyboard, the keyboard dismisses
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        
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
    
    // MARK: Action for "Done" button on the keyboard.
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    // MARK: Keyboard events
    // Event for pressing Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtAge {
            // When Return key is pressed, the focus goes to the next field
            txtWeight.becomeFirstResponder()
        }
        if textField == txtWeight {
            // When Return key is pressed, the focus goes to the next field
            txtHeight.resignFirstResponder()
            
        }
        
        return true
    }
    
    
    
    @IBAction func nextBtn(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        ref?.child("users").child(user!.uid).updateChildValues(["Age" : self.txtAge.text!, "Weight" : self.txtWeight.text!, "Height" : self.txtHeight.text!])
    }
    
    
}
