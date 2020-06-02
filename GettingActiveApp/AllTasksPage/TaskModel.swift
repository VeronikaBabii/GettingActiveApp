
//  TaskModel.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 28.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Task {
    var title: String
    var description: String
    var tip: String
    var hashtags: String

    var dictionary:[String:Any] {
        return [
            "title": title,
            "description": description,
            "tip": tip,
            "hashtags": hashtags
        ]
    }

    func parseData(snapshot: QuerySnapshot?) -> [Task] {

        var tasks = [Task]()

        guard let snap = snapshot else { return tasks }
        for document in snap.documents {
            let data = document.data()
            let title = data["title"] as? String ?? ""
            let description = data["description"] as? String ?? ""
            let tip = data["tip"] as? String ?? ""
            let hashtags = data["hashtags"] as? String ?? ""

            let task = Task(title: title, description: description, tip: tip, hashtags: hashtags)
            tasks.append(task)
        }

        return tasks
    }
}

extension Task : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let tip = dictionary["tip"] as? String,
            let hashtags = dictionary["hashtags"] as? String else {return nil}

        self.init(title: title, description: description, tip: tip, hashtags: hashtags)
    }
}



