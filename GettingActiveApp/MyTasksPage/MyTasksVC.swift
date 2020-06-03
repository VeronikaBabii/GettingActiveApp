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
        //setUpDesign()
        loadData()

    }

    func setUpDesign() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    }

    func loadData() {

    }



}

extension MyTasksVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        //return myTasksArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "myTaskCell") as! MyTaskTableViewCell

//        let task = myTasksArray[indexPath.row]
//
//        cell.myTitle.text = task.title
//        cell.myDescription.text = task.description
//        cell.myTipLabel.text = task.tip
//        cell.myHashtags.text = task.hashtags

        return cell
    }
}
