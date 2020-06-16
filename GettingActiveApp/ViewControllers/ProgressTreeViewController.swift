//
//  ProgressTreeViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 12.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProgressTreeViewController: UIViewController {
    
    var db = Firestore.firestore()
    
    @IBOutlet weak var treeImage: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBadges()
        checkForCountUpdates()
    }
    
    func setBadges() {
        
        let userID = Auth.auth().currentUser!.uid
        let archiveCollRef = db.collection("users").document(userID).collection("archive")
        
        archiveCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                
                // count snapshots in a collection - number of tasks in archive
                var count = 0
                for _ in queryShapshot!.documents {
                    count += 1
                }
                
                // count number of tasks, badges = count * 5
                // switch for different number of tasks and set appropriate images
                switch count {
                case 0:
                    print("0")
                    self.progressLabel.text = "Ти на 0 рівні :("
                    self.treeImage.image = UIImage(named: "tree-0")
                case 1:
                    print("\nLevel 1: 5-20 points")
                    self.progressLabel.text = "Ти на 1 рівні!"
                    self.treeImage.image = UIImage(named: "tree-1")
                case 4:
                    print("\nLevel 2: 25-40 points")
                    self.progressLabel.text = "Ти на 2 рівні!"
                    self.treeImage.image = UIImage(named: "tree-2")
                case 8:
                    print("\nLevel 3: 45-60 points")
                    self.progressLabel.text = "Ти на 3 рівні!"
                    self.treeImage.image = UIImage(named: "tree-3")
                case 12:
                    print("\nLevel 4: 65-80 points")
                    self.progressLabel.text = "Ти на 4 рівні!"
                    self.treeImage.image = UIImage(named: "tree-4")
                case 16:
                    print("\nLevel 5: 85-100 points")
                    self.progressLabel.text = "Ти на 5 рівні! Вітаю!"
                    self.treeImage.image = UIImage(named: "tree-5")
                default:
                    print("Default")
                }
            }
        }
    }
    
    func checkForCountUpdates() {
        let userID = Auth.auth().currentUser!.uid
        let archiveCollRef = db.collection("users").document(userID).collection("archive")
        
        archiveCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                
                // listen to archive collection
                archiveCollRef.addSnapshotListener() {
                    querySnapshot, error in
                    
                    guard let snapshot = querySnapshot else {return}
                    
                    snapshot.documentChanges.forEach {
                        diff in
                        
                        // if action is addition - count number of done tasks again
                        if diff.type == .added {
                            
                            var count = 0
                            for _ in querySnapshot!.documents {
                                count += 1
                            }
                            
                            switch count {
                            case 0:
                                print("0")
                                self.progressLabel.text = "Ти на 0 рівні :("
                                self.treeImage.image = UIImage(named: "tree-0")
                            case 1:
                                print("\nLevel 1: 5-20 points")
                                self.progressLabel.text = "Ти на 1 рівні!"
                                self.treeImage.image = UIImage(named: "tree-1")
                            case 4:
                                print("\nLevel 2: 25-40 points")
                                self.progressLabel.text = "Ти на 2 рівні!"
                                self.treeImage.image = UIImage(named: "tree-2")
                            case 8:
                                print("\nLevel 3: 45-60 points")
                                self.progressLabel.text = "Ти на 3 рівні!"
                                self.treeImage.image = UIImage(named: "tree-3")
                            case 12:
                                print("\nLevel 4: 65-80 points")
                                self.progressLabel.text = "Ти на 4 рівні!"
                                self.treeImage.image = UIImage(named: "tree-4")
                            case 16:
                                print("\nLevel 5: 85-100 points")
                                self.progressLabel.text = "Ти на 5 рівні! Вітаю!"
                                self.treeImage.image = UIImage(named: "tree-5")
                            default:
                                print("Default")
                            }
                        }
                    }
                }
            }
        }
    }
}
