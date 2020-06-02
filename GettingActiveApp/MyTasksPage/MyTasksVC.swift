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

        
    }
    
    
    
}

extension MyTasksVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTaskCell") as! MyTaskTableViewCell
        
        
        
        return cell
    }
}
