//
//  TaskModel.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 28.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import Foundation
import FirebaseFirestore

//class TaskModel {
//
//    var taskModelTitle: String?
//    var taskModelHashtags: String?
//    var taskModelTip: String?
//
//    init(taskModelTitle: String?, taskModelHashtags: String?, taskModelTip: String?) {
//        self.taskModelTitle = taskModelTitle
//        self.taskModelHashtags = taskModelHashtags
//        self.taskModelTip = taskModelTip
//    }
//}


protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Task {
    var title: String
    var tip: String
    var hashtags: String
    
    var dictionary:[String:Any] {
        return [
            "title": title,
            "tip": tip,
            "hashtags": hashtags
        ]
    }
}

extension Task : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String,
            let tip = dictionary["tip"] as? String,
            let hashtags = dictionary["hashtags"] as? String else {return nil}
        
        self.init(title: title, tip: tip, hashtags: hashtags)
    }
}

