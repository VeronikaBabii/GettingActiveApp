//
//  MyTasksVC.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 02.06.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MyTasksVC: UIViewController {

    var db = Firestore.firestore()
    var myTasksArray = [Task]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        loadData()
        checkForUpdates()
    }

    // load data from the myTasks collection to the tableview
    func loadData() {
        let userID = Auth.auth().currentUser!.uid
        let userMyTasksCollRef = db.collection("users").document(userID).collection("myTasks")
        
        userMyTasksCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("Error loading data: \(error.localizedDescription)")
            } else {
                self.myTasksArray = queryShapshot!.documents.compactMap({Task(dictionary: $0.data())})
                
                print("Snapshots are \(queryShapshot!.documents)")
                print("My tasks array is \(self.myTasksArray)")
                
                // update user interface
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // listen to the db and reload tableview when data is added
    func checkForUpdates() {
        let userID = Auth.auth().currentUser!.uid
        let userMyTasksCollRef = db.collection("users").document(userID).collection("myTasks")
        
        userMyTasksCollRef.addSnapshotListener() {
            querySnapshot, error in
            
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach {
                diff in
                
                // if changes action is addition, then add task and reload
                if diff.type == .added {
                    self.myTasksArray.append(Task(dictionary: diff.document.data())!)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                // if changes action is deletion
                if diff.type == .removed {
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func setUpDesign() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    }
}

extension MyTasksVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTasksArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "myTaskCell") as! MyTaskTableViewCell

        let task = myTasksArray[indexPath.row]

        cell.myTitle.text = task.title
        cell.myDescription.text = task.description
        cell.myTipLabel.text = task.tip
        cell.myHashtags.text = task.hashtags

        return cell
    }
}
