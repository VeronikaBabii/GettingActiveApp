//
//  TaskModalVC.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 27.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TaskModalVC: UIViewController {

    let db = Firestore.firestore()
    
    // outlets
    @IBOutlet weak var modalTitle: UILabel!
    @IBOutlet weak var modalDescription: UILabel!
    @IBOutlet weak var modalImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    // close popup when outside popup is clicked
    @IBAction func dismissPopup(_ sender: UIButton) {
        // add changing the title of the "I'm in" button to "Continue"
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // actions
    @IBAction func doneButtonTapped(_ sender: Any) {
        // add moving the done task to the archive
        
        dismiss(animated: true, completion: nil)
    }
    
}
