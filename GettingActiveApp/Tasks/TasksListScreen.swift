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
        addTasks()
        setUpDesign()
        loadData()
        downloadImage()
    }
    
    // push tasks to the db
    func addTasks() {
        
        let userID = Auth.auth().currentUser!.uid
        let tasksCollRef = db.collection("users").document(userID).collection("tasks")
        
        tasksCollRef.document("1").setData([
            "title": "Копійка гривню береже",
            "description": "Копійка гривню береже, чули таке? Чи є у Вас скарбничка? Якщо немає - є ідея. Спробуйте створити скарбничку своїми руками. Яка вона буде - справа Ваша. І ще, порада, заповніть ії.",
            "tip": "Живеться, якщо копійка ведеться",
            "hashtags": "#гроші #збереження #своїми руками"
        ])
        
        tasksCollRef.document("2").setData([
            "title": "В здоровому тілі - здоровий дух",
            "description": "Зробіть ранкову зарядку або пробіжку на свіжому повітрі.",
            "tip": "Фізична активність значно покращує самопочуття на цілий день",
            "hashtags": "#розвиток #фізична активність #здоров'я"
        ])
        
        tasksCollRef.document("3").setData([
            "title": "Гарна книга - мудрий вчитель",
            "description": "Виберіть книжку, яку б вам хотілося прочитати: це може бути художня література, наукові підручники або пізнавальні книжки та почніть читати.",
            "tip": "Збагачуйте свій внутрішній світ та дізнавайтесь багато цікавого",
            "hashtags": "#розвиток #знання #навчання #книжки"
        ])
        
        // deleted tag
        tasksCollRef.document("4").setData([
            "title": "Збалансований розум та самопочуття понад усе",
            "description": "Помедитуйте під заспокійливу музику: заплющте очі, зосередьте увагу на своєму диханні та ні про що не думайте. Почніть практикувати медитацію принаймні з 5 хвилин та щодня збільшуйте час медитації.",
            "tip": "Дозвольте своїм думкам вільно блукати у вашій голові",
            "hashtags": "#розвиток #здоров'я #відпочинок"
        ])
        
        tasksCollRef.document("5").setData([
            "title": "Проводьте більше часу зі своїми рідними",
            "description": "Проведіть трохи часу зі своїми близькими людьми: ви можете просто відпочити, переглядаючи ваш улюблений фільм, або допомогти вашим батькам у приготуванні їжі, прибиранні, тощо.",
            "tip": "Цінуйте та не втрачайте час, який ви можете провести з рідними людьми",
            "hashtags": "#родина #допомога #сім'я #побут"
        ])
        
        tasksCollRef.document("6").setData([
            "title": "Заведіть кімнатну рослину",
            "description": "Придбайте собі кімнатну рослинку. Якщо у вас немає часу постійно доглядати за рослинкою, ви можете купити кактус, спатіфілюм або хлорофітум, вони не потребують постійного догляду та поливу.",
            "tip": "Рослина збагачує кімнату киснем та прикрашає інтер'єр",
            "hashtags": "#розвиток #відпочинок #побут"
        ])
        
        // deleted hashtag
        tasksCollRef.document("7").setData([
            "title": "Записник",
            "description": "Заведіть записник або щоденник, в який ви зможете записувати свої плани на майбутнє, побутові справи на день або креативні думки та ідеї.",
            "tip": "Записник допоможе вам запам'ятати необхідні справи на день",
            "hashtags": "#розвиток #творчість #побут #робота"
        ])
        
        tasksCollRef.document("8").setData([
            "title": "Де не вистачає слів - говорить музика",
            "description": "Щоб трохи відпочити від буденних справ, пропонуємо вам послухати улюблену музику, поспівати або ще цікавіше - навчитися грати її на музичному інструменті.",
            "tip": "Музика дозволить вам відпочити та підніме настрій",
            "hashtags": "#розвиток #музика #відпочинок #хобі"
        ])
        
        tasksCollRef.document("9").setData([
            "title": "Проводьте час в інтернеті з користю",
            "description": "Подивіться документальний фільм, який ви ще не бачили або прочитайте цікаву статтю.",
            "tip": "Рекомендуємо вам подивитися відео на каналі TED :)",
            "hashtags": "#відпочинок #розвиток #інтернет"
        ])
        
        tasksCollRef.document("10").setData([
            "title": "Навчання ніколи не буває зайвим",
            "description": "Запишіться на курси: це можуть бути мовні курси, підвищення вашої робочої кваліфікації або щось, що припаде вам до смаку (уроки акторської майстерності, танці, малювання або дизайн).",
            "tip": "Coursera - сайт, на якому ви знайдете будь-які курси",
            "hashtags": "#навчання #розвиток #хобі #робота #творчість"
        ])
        
    }
    
    
//    func addTasks() {
//        
//        // push tasks to the db
//        
//        // copy to db.collection("users").document(userID)
//        // from db.collection("tasks").document("firstBundle").collection("tasks")
//        
//        let userID = Auth.auth().currentUser!.uid
//        let userRef = db.collection("users").document(userID)
//        
//        let tasksCollRef = db.collection("users").document(userID).collection("tasks")
//        
//        let firstBundleCollRef = db.collection("tasks").document("firstBundle").collection("tasks")
//        
//        firstBundleCollRef.getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err.localizedDescription)")
//            } else {
//                if let snapshot = querySnapshot {
//                    for document in snapshot.documents {
//                        let data = document.data()
//                        let batch = self.db.batch()
//                        let docset = querySnapshot
//                        
//                        let newCollRef = userRef.collection("tasks").document()
//                        
//                        docset?.documents.forEach {_ in batch.setData(data, forDocument: newCollRef)}
//                        
//                        batch.commit(completion: { (error) in
//                            if let error = error {
//                                print(error.localizedDescription)
//                            } else {
//                                print("Successfuly copied docs")
//                                // print(data)
//                            }
//                        })
//                    }
//                }
//            }
//        }
    
    
    
    func setUpDesign() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        sayHello()
    }
    
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
    
    func downloadImage() {
        let storageRef = Storage.storage().reference().child("imagesFolder").child("task1.png")
        storageRef.downloadURL { (url, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            //print("Image URL: \((url?.absoluteString)!)")
        }
    }
    
    // load data from db
    
    // error here
    func loadData() {
        let userID = Auth.auth().currentUser!.uid
        let tasksCollRef = db.collection("users").document(userID).collection("tasks")
        
        tasksCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.tasksArray = queryShapshot!.documents.compactMap({Task(dictionary: $0.data())})
                print("Data: \(self.tasksArray)")
                // to update user interface
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        cell.previewMotivLabel.text = task.description
        cell.previewTipLabel.text = task.tip
        cell.previewHashtagsLabel.text = task.hashtags
        //cell.previewImageView.image = UIImage(contentsOfFile: task.imageURL)
        
        //print("Image URL is \(task.imageURL)")
        
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
            
        }
    }
    
    // if tasksArray.count = 0, add new 10 tasks to the tableview
    
    
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
            "description": tasksArray[indexPath.row].description,
            "tip": tasksArray[indexPath.row].tip,
            "hashtags": tasksArray[indexPath.row].hashtags
        ])
        
        // print current archive collection size
        archiveCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                var count = 0
                for document in queryShapshot!.documents {
                    count += 1
                    //print("\(document.documentID) => \(document.data())");
                }
                //print("Number of archived tasks = \(count)");
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
