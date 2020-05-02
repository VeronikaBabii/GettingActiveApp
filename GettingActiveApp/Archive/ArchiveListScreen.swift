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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        loadData()
        listenToArchiveCollection()
        self.tableView.reloadData()
    }
    
    func setUpDesign() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    }
    
    // add listener
    func listenToArchiveCollection() {
        db.collection("archive").addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.tableView.reloadData()
            }
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
}

extension ArchiveListScreen: UITableViewDataSource, UITableViewDelegate {
    
    // number of tasks
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archiveTasksArray.count
    }
    
    // add task to the archive page table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCell") as! ArchiveViewCell
        
        let task = archiveTasksArray[indexPath.row]
        
        cell.archiveTitle.text = task.title
        cell.archiveDescription.text = task.description
        cell.archiveTipLabel.text = task.tip
        cell.archiveHashtags.text = task.hashtags
        
        return cell
    }
}
