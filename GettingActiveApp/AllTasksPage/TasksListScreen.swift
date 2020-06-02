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
    var tasksArray = [Task]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helloLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addTasks()
        setUpDesign()
        loadData()
    }

     //push tasks to the db
//            func addTasks() {
//
//                // copy from db.collection("tasks").document("firstBundle").collection("tasks") = tasksFirstBundleCollRef
//                // to db.collection("users").document(userID) = userDocRef
//
//                let userID = Auth.auth().currentUser!.uid
//                let userRef = db.collection("users").document(userID)
//                let tasksFirstBundleCollRef = db.collection("tasks").document("firstBundle").collection("tasks")
//
//                tasksFirstBundleCollRef.getDocuments { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err.localizedDescription)")
//                    } else {
//                        if let snapshot = querySnapshot {
//                            for document in snapshot.documents {
//                                let data = document.data()
//                                let batch = self.db.batch()
//                                let docset = querySnapshot
//
//                                let newCollRef = userRef.collection("tasks").document()
//
//                                docset?.documents.forEach {_ in batch.setData(data, forDocument: newCollRef)}
//
//                                batch.commit(completion: { (error) in
//                                    if let error = error {
//                                        print(error.localizedDescription)
//                                    } else {
//                                        print("Successfuly copied doc")
//                                        // shouldn't have data here because we convert it later in loadData() method
//                                    }
//                                })
//                            }
//                        }
//                    }
//                }
//            }

    // load data to the table view from the db
    func loadData() {
        let userID = Auth.auth().currentUser!.uid
        let userTasksCollRef = db.collection("users").document(userID).collection("tasks")

        // get data from userTasksCollRef that we passed in in the addTasks() method
        userTasksCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("Error loading data: \(error.localizedDescription)")
            } else {
                self.tasksArray = queryShapshot!.documents.compactMap({Task(dictionary: $0.data())}) // we convert it here
                print("Data: \(self.tasksArray)") // so we have data here
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func setUpDesign() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
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
                        self.helloLabel.text = "Hello, \(userFirstname)!"
                    }
                }
            }
        }
    }

    //push tasks to the db
    func addTasks() {

        let userID = Auth.auth().currentUser!.uid
        let userTasksCollRef = db.collection("users").document(userID).collection("tasks")

        userTasksCollRef.addDocument(data: [
            "title": "Копійка гривню береже",
            "description": "Копійка гривню береже, чули таке? Чи є у Вас скарбничка? Якщо немає - є ідея. Спробуйте створити скарбничку своїми руками. Яка вона буде - справа Ваша. І ще, порада, заповніть ії.",
            "tip": "Живеться, якщо копійка ведеться",
            "hashtags": "#гроші #збереження #своїми руками"
        ])

        userTasksCollRef.addDocument(data: [
            "title": "В здоровому тілі - здоровий дух",
            "description": "Зробіть ранкову зарядку або пробіжку на свіжому повітрі.",
            "tip": "Фізична активність значно покращує самопочуття на цілий день",
            "hashtags": "#розвиток #фізична активність #здоров'я"
        ])

        userTasksCollRef.addDocument(data: [
            "title": "Гарна книга - мудрий вчитель",
            "description": "Виберіть книжку, яку б вам хотілося прочитати: це може бути художня література, наукові підручники або пізнавальні книжки та почніть читати.",
            "tip": "Збагачуйте свій внутрішній світ та дізнавайтесь багато цікавого",
            "hashtags": "#розвиток #знання #навчання #книжки"
        ])

        userTasksCollRef.addDocument(data: [
            "title": "Збалансований розум та самопочуття понад усе",
            "description": "Помедитуйте під заспокійливу музику: заплющте очі, зосередьте увагу на своєму диханні та ні про що не думайте. Почніть практикувати медитацію принаймні з 5 хвилин та щодня збільшуйте час медитації.",
            "tip": "Дозвольте своїм думкам вільно блукати у вашій голові",
            "hashtags": "#розвиток #здоров'я #відпочинок"
        ])

        userTasksCollRef.addDocument(data: [
            "title": "Проводьте більше часу зі своїми рідними",
            "description": "Проведіть трохи часу зі своїми близькими людьми: ви можете просто відпочити, переглядаючи ваш улюблений фільм, або допомогти вашим батькам у приготуванні їжі, прибиранні, тощо.",
            "tip": "Цінуйте та не втрачайте час, який ви можете провести з рідними людьми",
            "hashtags": "#родина #допомога #сім'я #побут"
        ])

        userTasksCollRef.addDocument(data: [
            "title": "Заведіть кімнатну рослину",
            "description": "Придбайте собі кімнатну рослинку. Якщо у вас немає часу постійно доглядати за рослинкою, ви можете купити кактус, спатіфілюм або хлорофітум, вони не потребують постійного догляду та поливу.",
            "tip": "Рослина збагачує кімнату киснем та прикрашає інтер'єр",
            "hashtags": "#розвиток #відпочинок #побут"
        ])

        userTasksCollRef.addDocument(data: [
            "title": "Записник",
            "description": "Заведіть записник або щоденник, в який ви зможете записувати свої плани на майбутнє, побутові справи на день або креативні думки та ідеї.",
            "tip": "Записник допоможе вам запам'ятати необхідні справи на день",
            "hashtags": "#розвиток #творчість #побут #робота"
        ])

        userTasksCollRef.addDocument(data: [
            "title": "Де не вистачає слів - говорить музика",
            "description": "Щоб трохи відпочити від буденних справ, пропонуємо вам послухати улюблену музику, поспівати або ще цікавіше - навчитися грати її на музичному інструменті.",
            "tip": "Музика дозволить вам відпочити та підніме настрій",
            "hashtags": "#розвиток #музика #відпочинок #хобі"
        ])

        userTasksCollRef.addDocument(data: [
            "title": "Проводьте час в інтернеті з користю",
            "description": "Подивіться документальний фільм, який ви ще не бачили або прочитайте цікаву статтю.",
            "tip": "Рекомендуємо вам подивитися відео на каналі TED :)",
            "hashtags": "#відпочинок #розвиток #інтернет"
        ])

        userTasksCollRef.addDocument(data: [
            "title": "Навчання ніколи не буває зайвим",
            "description": "Запишіться на курси: це можуть бути мовні курси, підвищення вашої робочої кваліфікації або щось, що припаде вам до смаку (уроки акторської майстерності, танці, малювання або дизайн).",
            "tip": "Coursera - сайт, на якому ви знайдете будь-які курси",
            "hashtags": "#навчання #розвиток #хобі #робота #творчість"
        ])
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
