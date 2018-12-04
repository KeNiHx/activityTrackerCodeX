//
//  RegistrationChoosingPhotoViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-25.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import DSLoadable

//make import to the firebase storage

class RegistrationChoosingPhotoViewController: UIViewController, UINavigationControllerDelegate {

    /**
     @IBOutlets
     @brief Outlets needed for the view controller.
    */
    @IBOutlet weak var btnPhotoPicker: UIButton!
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    @IBOutlet weak var btnFinish: UIButton!
    var imagePicker: UIImagePickerController!
    
    // MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Function for choosing the user's photo
    @IBAction func choosePhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Profile Photo", message: "Choose your available options.", preferredStyle: .actionSheet)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        alert.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { (UIAlertAction) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { (UIAlertAction) in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Tells the delegate that the user cancelled the pick operation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Upload the media to the storage
    @IBAction func clickBtnSavePhoto(_ sender: UIButton) {
        guard let image = imgProfilePhoto.image else { return }
        
        // Upload the profile image to Firebase Storage
        self.uploadProfileImage(image) { url in
            
            if url != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                
                changeRequest?.commitChanges { error in
                    if error == nil {
                        self.saveProfile( profileImageURL: url!) { success in
                            if success {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } else {
                        print("COMMIT CHANGES ERROR: \(error!.localizedDescription)")
                    }
                    
                    // Once everything is uploaded and updated (photo, photoURL), present the Today View Controller
                    if let home = (self.storyboard?.instantiateViewController(withIdentifier: "MainStoryboardID") as? UITabBarController) {
                        self.present(home, animated: true, completion: nil)
                    }
                }
            } else {
                print("URL IS NIL: \(url.debugDescription)")
            }
        }
    }
    
    // MARK: - Gets the image from the UIImageView and uploads it to the storage
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("users/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("THE URL: \(url!.absoluteString)")
                        completion(url)
                    }
                })
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - Function for adding a photoURL field in the user's data
    func saveProfile(profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let databaseRef = Database.database().reference().child("users/\(uid)")
        
        databaseRef.child("info").updateChildValues(["photoURL" : profileImageURL.absoluteString])
    }
}

extension RegistrationChoosingPhotoViewController: UIImagePickerControllerDelegate {
    // Mark: - Tells the Delagate that the user picked a still image or movie
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        
        // Remove the "Add Photo" text from the invisible button
        btnPhotoPicker.setTitle("", for: .normal)
        
        guard let pickedImage = info[.originalImage] as? UIImage else {
            print("ERRORRRRRR!!!")
            return
        }
        self.imgProfilePhoto.image = pickedImage // Sets what image is it
        self.imgProfilePhoto.contentMode = .scaleAspectFill // Sets the photo to fill the whole frame
    
        // Once the photo is displayed, enable the button and change it to "Save Photo"
        btnFinish.isEnabled = true
        btnFinish.alpha = 1.0
        btnFinish.setTitle("Save Photo", for: .normal)
        btnFinish.loadableStartLoading()
    }
}

