//
//  RegistrationChoosingPhotoViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-25.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import MMSProfileImagePicker

class RegistrationChoosingPhotoViewController: UIViewController {

    /**
     @IBOutlets
     @brief Outlets needed for the view controller.
    */
    @IBOutlet weak var btnPhotoPicker: UIButton!
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Function for choosing the user's photo
    @IBAction func choosePhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Profile Photo", message: "Choose your available options.", preferredStyle: .actionSheet)
        
        let picker = MMSProfileImagePicker.init()
        
        alert.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { (UIAlertAction) in
                picker.delegate = self as? MMSProfileImagePickerDelegate
                picker.select(fromCamera: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { (UIAlertAction) in
                picker.delegate = self as? MMSProfileImagePickerDelegate
                picker.select(fromPhotoLibrary: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
