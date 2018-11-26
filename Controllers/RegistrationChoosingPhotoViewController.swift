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
        let alert = UIAlertController(title: "Profile Photo", message: "Choose your available options.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { (UIAlertAction) in
                let takePhoto = MMSProfileImagePicker.init()
                takePhoto.delegate = self as? MMSProfileImagePickerDelegate
                takePhoto.select(fromCamera: takePhoto)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { (UIAlertAction) in
                let chooseFromLibrary = MMSProfileImagePicker.init()
                chooseFromLibrary.delegate = self as? MMSProfileImagePickerDelegate
                chooseFromLibrary.select(fromPhotoLibrary: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
