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
import FirebaseStorage

class TasksListScreen: UIViewController {
    
    var db = Firestore.firestore()
    var tasksArray = [Task]() // array of tasks
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        
        sayHello()
        loadData()
        downloadImage()
    }
    
    func downloadImage() {
        let storageRef = Storage.storage().reference().child("imagesFolder").child("task1.png")
        storageRef.downloadURL { (url, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            print("Image URL: \((url?.absoluteString)!)")
        }
    }
    
    // load data from db
    func loadData() {
        let userID = Auth.auth().currentUser!.uid
        let tasksCollRef = db.collection("users").document(userID).collection("tasks")
        
        tasksCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.tasksArray = queryShapshot!.documents.compactMap({Task(dictionary: $0.data())})
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
        cell.previewMotivLabel.text = task.tip
        cell.previewHashtagsLabel.text = task.hashtags
        //cell.previewImageView.image = UIImage(contentsOfFile: task.imageURL)
        
        print("Image URL is \(task.imageURL)")
        
        return cell
    }
    
    // swipe right - task deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // if action is deletion
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            // delete task from db for the current user
            let title = tasksArray[indexPath.row].title
            let user = Auth.auth().currentUser
            // access collection of tasks of the current user
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
            
            // add new task to the db instead of deleted one
            let userID = Auth.auth().currentUser!.uid
            let tasksCollRef = db.collection("users").document(userID).collection("tasks")
            
            tasksCollRef.document("taskNew").setData([
                "title": "Заведіть кімнатну рослину",
                "tip": "Заведіть собі кімнатну рослинку, вона не тілки прикрасить інтер'єр вашої кімнати, а й наповнить її киснем.",
                "hashtags": "#розвиток #відпочинок #побут",
                "imageURL": ""
            ])
            
            // add new task to the table view
            
            
            
        }
    }
    
    // swipe left - task done
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let complete = completeAction(at: indexPath)
        
        // delete done task from db for the current user
        let title = tasksArray[indexPath.row].title
        let user = Auth.auth().currentUser
        let collectionRef = db.collection("users").document((user?.uid)!).collection("tasks")
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
        
        // create archive collection and push done task in it
        let userID = Auth.auth().currentUser!.uid
        let archiveCollRef = db.collection("users").document(userID).collection("archive")
        
        archiveCollRef.addDocument(data: [
            "title": tasksArray[indexPath.row].title,
            "tip": tasksArray[indexPath.row].tip,
            "hashtags": tasksArray[indexPath.row].hashtags,
            "imageURL": tasksArray[indexPath.row].imageURL
        ])
        
        // print current archive collection size
        archiveCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                var count = 0
                for document in queryShapshot!.documents {
                    count += 1
                    print("\(document.documentID) => \(document.data())");
                }
                print("Number of archived tasks = \(count)");
            }
        }
        
        return UISwipeActionsConfiguration(actions: [complete])
    }
    
    // swipe left - done task, helper func
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        // remove task from table view
        let action = UIContextualAction(style: .destructive, title: "Complete") { (action, view, completion) in
            self.tasksArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.title = "Done"
        action.backgroundColor = .green
        
        return action
    }
}
