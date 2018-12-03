//
//  RegistrationChoosingPhotoViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-25.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import MMSProfileImagePicker
import MobileCoreServices
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

//make import to the firebase storage

class RegistrationChoosingPhotoViewController: UIViewController, UINavigationControllerDelegate {

    /**
     @IBOutlets
     @brief Outlets needed for the view controller.
    */
    @IBOutlet weak var btnPhotoPicker: UIButton!
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    var imagePicker: UIImagePickerController!
//    let kUTTypeImage: CFString
    @IBOutlet weak var btnSavePhoto: UIButton!
    @IBOutlet weak var btnFinishSetup: UIButton!
    
 override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Function for choosing the user's photo
    @IBAction func choosePhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Profile Photo", message: "Choose your available options.", preferredStyle: .actionSheet)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        alert.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { (UIAlertAction) in
//            picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { (UIAlertAction) in
//                picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //Mark: - Tells the delegate that the user cancelled the pick operation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }

    // Mark: - Upload the media to the storage
    
    
    
    
    @IBAction func clickBtnSavePhoto(_ sender: UIButton) {
        
        print("SAVE PHOTO FUNCTION")
        
        guard let image = imgProfilePhoto.image else { return }
        
        // 1. Upload the profile image to Firebase Storage
        
        self.uploadProfileImage(image) { url in
            
            if url != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                
                changeRequest?.commitChanges { error in
                    if error == nil {
                        self.saveProfile( profileImageURL: url!) { success in
                            if success {
                                print("DISMISSING...")
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } else {
                        print("COMMIT CHANGES ERROR: \(error!.localizedDescription)")
                    }
                    
                    // Mark: - Once an image has been saved the button will go back to normal
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodayViewBoardID") as! TodayViewController
                    
                    self.present(vc, animated:  true, completion: nil)
                    
                }
            } else {
                print("URL IS NIL: \(url.debugDescription)")
            }
            
        }
    }
    
    // Mark: - If the user does not want a photo it will pull a default image from the database and store it into the database and go to the home view page
    @IBAction func clickBtnFinishSetup(_ sender: UIButton) {
        
        //Set the default image as the image.
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TodayViewBoardID") as! TodayViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
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
    
    func saveProfile(profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("SOMETHING WENT WRONG WITH THE UID!!!!!!!!!!!!!!!!")
            return
        }
        let databaseRef = Database.database().reference().child("users/\(uid)")
        
        databaseRef.updateChildValues(["PhotoURL" : profileImageURL.absoluteString])
//        let user = Auth.auth().currentUser
//
//        databaseRef?.child("users").child(user!.uid).updateChildValues(["ImageURL" : profileImageURL.absoluteString])
//
        print("This function works!")
    }
    
    
    
}

extension RegistrationChoosingPhotoViewController: UIImagePickerControllerDelegate {
    // Mark: - Tells the Delagate that the user picked a still image or movie
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
      
        guard let pickedImage = info[.originalImage] as? UIImage else {
            print("ERRORRRRRR!!!")
            return
        }
        
        print("THERE'S AN IMAGE!!!!!")
        
        
        self.imgProfilePhoto.image = pickedImage // Sets what image is it
        self.imgProfilePhoto.contentMode = .scaleToFill // Sets the photo to fill the whole frame
        
        // MarK: - If an image is added enable the button to save it to the database
        btnSavePhoto.isEnabled = true
        btnSavePhoto.alpha = 1.0
    
        print("Button should be enabled!")
  
    }
}

