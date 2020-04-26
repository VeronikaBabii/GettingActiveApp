//
//  HomeViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 23.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sayHello()
    }
    
    // print "hello, userFirstname" message
    func sayHello() {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let currentUserDoc = snapshot?.documents.first(where: { ($0["uid"] as? String) == userId }) {
                       let userFirstname = currentUserDoc["firstname"] as! String
                       self.helloLabel.text = "Hello, \(userFirstname)!"
                    }
                }
            }
        }
    }
    
    //
    
    
}
