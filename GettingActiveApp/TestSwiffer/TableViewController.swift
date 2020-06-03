////
////  TableViewController.swift
////  GettingActiveApp
////
////  Created by Veronika Babii on 01.06.2020.
////  Copyright © 2020 Veronika Babii. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseFirestore
//
//
//class TableViewController: UITableViewController {
//
//    var db:Firestore!
//
//    var sweetArray = [Sweet]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        db = Firestore.firestore()
//
//        loadData()
//        //checkForUpdates()
//    }
//
//    func loadData() {
//        db.collection("sweets").getDocuments() {
//            querySnapshot, error in
//            if let error = error {
//                print("Error loading documents to the db: \(error.localizedDescription)")
//            } else {
//                // push sweets to sweetArray = get the array of currently available sweets in the db
//                // flatMap - to convert array of documents' snapshots into sweet data model format
//                self.sweetArray = querySnapshot!.documents.compactMap({Sweet(dictionary: $0.data())})
//
//                // problem is with parsing from snapshots
//                print("Snapshots are \(querySnapshot!.documents)")
//                print("Sweet array is \(self.sweetArray)")
//
//
//                // update user interface
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
//
//    func checkForUpdates() {
//        db.collection("sweets").whereField("timeStamp", isGreaterThan:Date())
//            .addSnapshotListener {
//                querySnapshot, error in
//
//                guard let snapshot = querySnapshot else {return}
//
//                snapshot.documentChanges.forEach {
//                    diff in
//
//                    // if changes action is addition, then add sweet and reload UI
//                    if diff.type == .added {
//                        self.sweetArray.append(Sweet(dictionary: diff.document.data())!)
//
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//        }
//
//    }
//
//    @IBAction func composeSweet(_ sender: Any) {
//
//           let composeAlert = UIAlertController(title: "New Sweet", message: "Enter your name and message", preferredStyle: .alert)
//
//           composeAlert.addTextField { (textField:UITextField) in
//               textField.placeholder = "Your name"
//           }
//
//           composeAlert.addTextField { (textField:UITextField) in
//               textField.placeholder = "Your message"
//           }
//
//           composeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//           composeAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
//
//            // check for information to send to db
//            if let name = composeAlert.textFields?.first?.text, let content = composeAlert.textFields?.last?.text {
//                // if both parameters are filled in, then create new sweet object
//                let newSweet = Sweet(name: name, content: content)
//
//                // add sweet to db
//                var ref:DocumentReference? = nil
//                ref = self.db.collection("sweets").addDocument(data: newSweet.dictionary) {
//                    error in
//
//                    if let error = error {
//                        print("Error adding document: \(error.localizedDescription)")
//                    } else {
//                        print("Document added with ID: \(ref!.documentID)")
//                    }
//                }
//            }
//           }))
//
//           self.present(composeAlert, animated: true, completion: nil)
//
//       }
//
//       override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//       }
//
//       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//           return sweetArray.count
//       }
//
//       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
//        let sweet = sweetArray[indexPath.row]
//
//        cell.textLabel?.text = "\(sweet.name) : \(sweet.content)"
//
//
//
//        return cell
//       }
//
//}
