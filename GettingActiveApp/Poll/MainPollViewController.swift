//
//  MainPollViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 08.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MainPollViewController: UIViewController {
    
    var db = Firestore.firestore()

    @IBOutlet weak var nowButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet var imageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.layer.cornerRadius = 8
        titleView?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        Utilities.activeButton(nowButton)
        Utilities.unactiveButton(laterButton)
    }
    
    // create collection with default tasks
    
    // push all tasks from firstBundle in user's collection without filtering by categories
    @IBAction func laterButtonTapped(_ sender: UIButton) {
        
        let userID = Auth.auth().currentUser!.uid
        let userDocRef = db.collection("users").document(userID)
        let tasksFirstBundleCollRef = db.collection("tasks").document("firstBundle").collection("tasks")
        
        tasksFirstBundleCollRef.getDocuments {
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err.localizedDescription)")
            } else {
                if let snapshot = querySnapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        let batch = self.db.batch()
                        let docset = querySnapshot
                        
                        let newCollRef = userDocRef.collection("tasks").document()
                        
                        docset?.documents.forEach {_ in batch.setData(data, forDocument: newCollRef)}
                        
                        batch.commit(completion: { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("Successfuly copied doc")
                            }
                        })
                    }
                }
            }
        }
    }
}
