//
//  RegisterRequiredInfoViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-22.
//  Copyright © 2018 CodeX. All rights reserved.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth

class RegisterRequiredInfoViewController: UIViewController, UITextFieldDelegate {
    
    /**
     @IBOutlets
     @brief Outlets needed for the view controller.
     */
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
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
    
    
    /**
     @var selectedGender
     @brief Temporary variable to know what gender is selected.
     */
    var selectedGender: String? = nil
    
    // MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addKeyboardListeners()
        ref = Database.database().reference()
        
    }
    
    // MARK: Chaning the status bar's style to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Function for the Next button's action
    @IBAction func nextPage(_ sender: UIButton) {
        if let user = Auth.auth().currentUser {
            ref?.child("users").child(user.uid).setValue(["First Name" : self.txtFirstName.text!, "Last Name" : self.txtLastName.text!, "Gender" : self.selectedGender!])
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionalInfoBoardID") as! MoreInfoViewController
            
            self.present(vc, animated: true, completion: nil)
            
            
        }
        
    }
    
    
    
    // MARK: - Functions for selecting gender
    // When selecting a gender, it should put its alpha to 100% (1.0) to let the user know that it is the correct choice—-50% (0.5) for the unselected choice.
    
    // Male Action
    @IBAction func selectedMale(_ sender: UIButton) {
        // "Selecting" the Male button
        selectedGender = "Male"
        btnMale.alpha = 1.0
        btnMale.layer.shadowOpacity = 0.2
        
        // "Deselecting" the Female button
        btnFemale.alpha = 0.5
        btnFemale.layer.shadowOpacity = 0
    }
    
    // Female Action
    @IBAction func selectedFemale(_ sender: UIButton) {
        // "Selecting" the Female button
        selectedGender = "Female"
        btnFemale.alpha = 1.0
        btnFemale.layer.shadowOpacity = 0.2
        
        // "Deselecting" the Male button
        btnMale.alpha = 0.5
        btnMale.layer.shadowOpacity = 0
    }
    
    // MARK: - Function for setting up the controller's UI
    private func setupUI() {
        txtFirstName.delegate = self
        txtLastName.delegate = self
        
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
        if textField == txtFirstName {
            // When Return key is pressed, the focus goes to the next field
            txtLastName.becomeFirstResponder()
        }
        if textField == txtLastName {
            // When Return key is pressed, the focus goes to the next field
            txtLastName.resignFirstResponder()
            
        }
        
        return true
    }
}
