//
//  ArchiveListScreen.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 01.05.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ArchiveListScreen: UIViewController {

    var db = Firestore.firestore()
    var archiveTasksArray = [Task]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTasksView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        loadData()
        checkForUpdates()
        ifEmptyTableView()
    }

    // load data from db
    func loadData() {
        let userID = Auth.auth().currentUser!.uid
        let archiveCollRef = db.collection("users").document(userID).collection("archive")

        archiveCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.archiveTasksArray = queryShapshot!.documents.compactMap({Task(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func checkForUpdates() {
        let userID = Auth.auth().currentUser!.uid
        let archiveCollRef = db.collection("users").document(userID).collection("archive")

        archiveCollRef.addSnapshotListener() {
            querySnapshot, error in

            guard let snapshot = querySnapshot else {return}

            snapshot.documentChanges.forEach {
                diff in
                
                // hide no tasks message
                self.tableView.backgroundView = nil

                // if changes action is addition, reload table view
                if diff.type == .added {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // show explanation message if no tasks were added to the archive collection yet (tableview is empty)
    func ifEmptyTableView() {
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
                
                // no tasks - tableview is empty
                if count == 0 {
                    self.tableView.backgroundView = self.noTasksView
                }
            }
        }
    }

    func setUpDesign() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    }
}

extension ArchiveListScreen: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archiveTasksArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCell") as! ArchiveViewCell

        let task = archiveTasksArray[indexPath.row]

        cell.archiveTitle.text = task.title
        cell.archiveDescription.text = task.description
        cell.archiveTipLabel.text = task.tip
        
        let hashtagsString = task.hashtags.map({$0}).joined(separator:" ")
        cell.archiveHashtags.text = hashtagsString

        return cell
    }
}
