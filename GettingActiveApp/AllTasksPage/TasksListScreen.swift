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
    
    var db = Firestore.firestore()
    var tasksArray = [Task]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        loadData()
        checkForUpdates()
    }
    
    // load data from the user tasks collection to the table view
    func loadData() {
        
        let userID = Auth.auth().currentUser!.uid
        let userTasksCollRef = db.collection("users").document(userID).collection("tasks")
        
        userTasksCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("Error loading data: \(error.localizedDescription)")
            } else {
                self.tasksArray = queryShapshot!.documents.compactMap({Task(dictionary: $0.data())})

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
        let userTasksCollRef = db.collection("users").document(userID).collection("tasks")
        
        userTasksCollRef.addSnapshotListener() {
            querySnapshot, error in
            
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach {
                diff in
                
                // if changes action is addition, then add task and reload
                if diff.type == .added {
                    self.tasksArray.append(Task(dictionary: diff.document.data())!)
                    
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
        
        tableView.separatorColor = UIColor(white: 1, alpha: 1)
        
        sayHello()
    }
    
    // add hello label to the page
    func sayHello() {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let currentUserDoc = snapshot?.documents.first(where: { ($0["uid"] as? String) == userId }) {
                        let userFirstname = currentUserDoc["firstname"] as! String
                        self.helloLabel.text = "Привіт, \(userFirstname)!"
                    }
                }
            }
        }
    }
}

extension TasksListScreen: TaskCellDelegate {
    
    // when "i'm in" button in task is tapped
    func didTapImInButton(index: Int) {
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let userTasksCollRef = db.collection("users").document(userID).collection("tasks")
        
        // search for task with needed title
        let query:Query = userTasksCollRef.whereField("title", isEqualTo: tasksArray[index].title)
        print(tasksArray[index].title)
        
        query.getDocuments(completion:{ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    
                    // create myTasks collection and push selected task to it
                    let userID = Auth.auth().currentUser!.uid
                    let myTasksCollRef = db.collection("users").document(userID).collection("myTasks")
                    
                    myTasksCollRef.addDocument(data: [
                        "title": self.tasksArray[index].title,
                        "description": self.tasksArray[index].description,
                        "tip": self.tasksArray[index].tip,
                        "hashtags": self.tasksArray[index].hashtags
                    ])
                    //print("Task added to myTasks coll")
                    
                    // remove selected task from users.tasks collection
                    self.tasksArray.remove(at: index)
                    userTasksCollRef.document("\(document.documentID)").delete()
                    //print("Task deleted from allTasks coll \n")
                }
            }
        })
    }
}

extension TasksListScreen: UITableViewDataSource, UITableViewDelegate {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    // add rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskViewCell
        
        let task = tasksArray[indexPath.row]
        
        cell.previewTitleLabel.text = task.title
        cell.previewMotivLabel.text = task.description
        cell.previewTipLabel.text = task.tip
        
        let hashtagsString = task.hashtags.map({$0}).joined(separator:" ")
        cell.previewHashtagsLabel.text = hashtagsString
        
        cell.styleButton()
        cell.cellDelegate = self
        cell.index = indexPath
        
        return cell
    }
    
    // swipe right - task deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // if action is deletion
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            // delete task from db for the current user
            let title = tasksArray[indexPath.row].title
            let user = Auth.auth().currentUser
            let collectionRef = db.collection("users").document((user?.uid)!).collection("tasks")
            
            // search for task with needed title
            let query : Query = collectionRef.whereField("title", isEqualTo: title)
            
            query.getDocuments(completion:{ (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        collectionRef.document("\(document.documentID)").delete()
                    }
                }
            })
            
            // delete task from table view
            tasksArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
