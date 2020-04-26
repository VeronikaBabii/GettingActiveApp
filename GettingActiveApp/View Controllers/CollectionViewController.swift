//
//  CollectionViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 25.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let db = Firestore.firestore()
    
    let taskTitle = ["Let's be productive!", "Let's be kind today!", "Sometimes you just need to relax!"]
    
    let taskMotivation = ["By learning how to do one new thing a day, you'll be capable of many things.", "Helping others is great.", "Taking care of yourself is the best gift you can give yourself."]
    
    let taskImage = [UIImage(named: ""), UIImage(named: ""), UIImage(named: "")]
    
    let taskHashtags = ["#productive #learn", "#kind #help", "#loveyourself #takecare"]
    
    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sayHello()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.taskTitleLabel.text = taskTitle[indexPath.row]
        cell.taskMotivationalTipLabel.text = taskMotivation[indexPath.row]
        cell.taskImage.image = taskImage[indexPath.row]
        cell.taskHashtagsLabel.text = taskHashtags[indexPath.row]
        
        // styling
        cell.contentView.layer.cornerRadius = 30
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.masksToBounds = false
        
        styleFilledButton(cell.taskOpenModalButton)
        styleHollowButton(cell.taskSkipButton)
        
        return cell
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
    
    // styling the buttons
    func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.white
    }
    
    func styleHollowButton(_ button:UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.black
    }
    

}
