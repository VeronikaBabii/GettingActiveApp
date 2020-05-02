//
//  ProfileViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 22.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    var archiveTasksArray = [Task]()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        setProgressBar()
    }
    
    // action to open image picker on click
    @IBAction func uploadImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
        //saveChanges()
    }
    
    // configure user progress bar
    func setProgressBar() {
        
       // print current archive collection size
        let userID = Auth.auth().currentUser!.uid
        let archiveCollRef = db.collection("users").document(userID).collection("archive")

        archiveCollRef.getDocuments { (queryShapshot, error) in
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            var count = 0
            for _ in queryShapshot!.documents {
                count += 1
            }
            print("Number of archived tasks = \(count)");
            
            self.progressLabel.text = "You've done \(count) tasks. Great job! "
            
            // set progress bar
            //let progress = Float(count/3)
            //print(progress)
           // self.progressBar.setProgress(progress, animated: true)
            
        }
        }
        
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    //
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // get user data from db
    func getUserData() {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let currentUserDoc = snapshot?.documents.first(where: { ($0["uid"] as? String) == userId }) {
                        
                        // get and set first and last name
                        let userFirstname = currentUserDoc["firstname"] as! String
                        let userLastname = currentUserDoc["lastname"] as! String
                        self.usernameLabel.text = "\(userFirstname) \(userLastname)"
                        
                        // get and set user picture
//                        if let profilePicURL = currentUserDoc["profilePic"] as? String {
//                            let url = URL(string: profilePicURL)
//
//                            URLSession.shared.dataTask(with: url!) { (data, response, error) in
//                                if error != nil {
//                                    print(error!)
//                                    return
//                                }
//                                DispatchQueue.main.async {
//                                    self.profileImage?.image = UIImage(data: data!)
//                                }
//                            }.resume()
//                        }
                    }
                }
            }
        }
    }
    
    // to save selected profile picture in the db
//    func saveChanges() {
//        let imageName = UUID().uuidString
//        // profileImages?
//        let imageRef = Storage.storage().reference().child("profileImages").child(imageName)
//
//        //if let uploadData = UIImage
//        imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
//            if let error = error {
//
//            }
//        }
//    }
}
