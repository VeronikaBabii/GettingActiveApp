
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
}

extension Task : DocumentSerializable {

    init?(dictionary: [String : Any]) {

            let title = dictionary["title"] as? String ?? "Error! Title Field Not Found!"
            let description = dictionary["description"] as? String ?? "Error! Description Field Not Found!"
            let tip = dictionary["tip"] as? String ?? "Error! Tip Field Not Found!"
            let hashtags = dictionary["hashtags"] as? String ?? "Error! Hashtags Field Not Found!"

        self.init(title: title, description: description, tip: tip, hashtags: hashtags)
    }
}



