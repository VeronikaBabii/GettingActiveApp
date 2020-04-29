//
//  TasksListScreen.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 26.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TasksListScreen: UIViewController {
    
    // variables
    var db = Firestore.firestore()
    var tasksArray = [Task]() // array of tasks
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sayHello()
        loadData()
    }
    
    // actions
    @IBAction func yesButtonTapped(_ sender: Any) {
         print("Hello")
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        print("Bye")
    }
    
    // functions
    // to load data from db
    func loadData() {
        db.collection("tasks").getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.tasksArray = queryShapshot!.documents.flatMap({Task(dictionary: $0.data())})
                // to update user interface
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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
        button.layer.cornerRadius = 15
        button.tintColor = UIColor.white
    }
    
    func styleHollowButton(_ button:UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.tintColor = UIColor.black
    }
}

extension TasksListScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskViewCell
        
        let task = tasksArray[indexPath.row]
        
        cell.previewTitleLabel.text = task.title
        cell.previewMotivLabel.text = task.tip
        cell.previewHashtagsLabel.text = task.hashtags
        // cell.previewImageView.image = tasksImage[indexPath.row]
        
        //let modal = tableView.dequeueReusableCell(withIdentifier: "taskModal")
        
        
        
        
        
        
        styleFilledButton(cell.openModalButton)
        styleHollowButton(cell.skipTaskButton)
        
        return cell
    }
}
