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

                //print("Snapshots are \(queryShapshot!.documents)")
                //print("My tasks array is \(self.myTasksArray)")

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

extension MyTasksVC: MyTaskCellDelegate {

    // when "done" button in task is tapped
    func didTapDoneButton(index: Int) {

        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let userMyTasksCollRef = db.collection("users").document(userID).collection("myTasks")

        // search for task with needed title
        let query:Query = userMyTasksCollRef.whereField("title", isEqualTo: myTasksArray[index].title)
        print(myTasksArray[index].title)

        query.getDocuments(completion:{ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {

                    // create archive collection and push done task in it
                    let userID = Auth.auth().currentUser!.uid
                    let archiveCollRef = db.collection("users").document(userID).collection("archive")

                    archiveCollRef.addDocument(data: [
                        "title": self.myTasksArray[index].title,
                        "description": self.myTasksArray[index].description,
                        "tip": self.myTasksArray[index].tip,
                        "hashtags": self.myTasksArray[index].hashtags
                    ])
                    print("Task added to archive coll")

                    // remove selected task from users.myTasks collection
                    self.myTasksArray.remove(at: index)
                    userMyTasksCollRef.document("\(document.documentID)").delete()
                    print("Task deleted from myTasks coll \n")
                }
            }
        })
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
        
        let hashtagsString = task.hashtags.map({$0}).joined(separator:" ")
        cell.myHashtags.text = hashtagsString

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
            let title = myTasksArray[indexPath.row].title
            let user = Auth.auth().currentUser
            let collectionRef = db.collection("users").document((user?.uid)!).collection("myTasks")
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
            myTasksArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
