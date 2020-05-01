//
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
    var tip: String
    var hashtags: String
    var imageURL: String
    
    var dictionary:[String:Any] {
        return [
            "title": title,
            "tip": tip,
            "hashtags": hashtags,
            "imageURL": imageURL
        ]
    }
}

extension Task : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String,
            let tip = dictionary["tip"] as? String,
            let hashtags = dictionary["hashtags"] as? String,
            let imageURL = dictionary["imageURL"] as? String else {return nil}
        
        self.init(title: title, tip: tip, hashtags: hashtags, imageURL: imageURL)
    }
}

