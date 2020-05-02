//
//  TaskViewCell.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 26.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher

struct Tasks {
    static let imagesFolder = "imagesFolder"
    static let imagesCollection = "imagesCollection"
    static let uid = "uid"
    static let imageURL = "imageUrl"
}

class TaskViewCell: UITableViewCell {
    
    var tasksArray = [Task]()
    
    @IBOutlet weak var previewTitleLabel: UILabel!
    @IBOutlet weak var previewMotivLabel: UILabel!
    @IBOutlet weak var previewHashtagsLabel: UILabel!
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    
    func uploadImage() {
        
        guard let image = previewImageView.image, let data = image.jpegData(compressionQuality: 1.0) else {
            print("Error!")
            return
        }
        
        let imageName = UUID().uuidString
        let imageRef = Storage.storage().reference().child("imagesFolder").child(imageName)
        
        
        imageRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            imageRef.downloadURL { (url, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                guard let url = url else {
                    print("Eror")
                    return
                }
                
                let userID = Auth.auth().currentUser!.uid
                let dataRef = Firestore.firestore().collection("users").document(userID)
                
                let docID = dataRef.documentID
                let urlString = url.absoluteString
                
                let data = [
                    Tasks.uid: docID,
                    Tasks.imageURL: urlString
                ]
                
                dataRef.setData(data) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    UserDefaults.standard.set(docID, forKey: Tasks.uid)
                }
                
            }
        }
    }
}
