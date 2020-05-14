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
        guard let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let tip = dictionary["tip"] as? String,
            let hashtags = dictionary["hashtags"] as? String else {return nil}
        
        self.init(title: title, description: description, tip: tip, hashtags: hashtags)
    }
}

//protocol DocumentSerializable {
//    init?(dictionary:[String:Any])
//}
//
//struct Task {
//    var title: String
//    var description: String
//    var tip: String
//    var hashtags: String
//    var hashtagsArray: [String]
//
//
//    var dictionary:[String:Any] {
//        return [
//            "title": title,
//            "description": description,
//            "tip": tip,
//            "hashtagsArray": hashtagsArray,
//            "hashtags": hashtags
//        ]
//    }
//}
//
//extension Task : DocumentSerializable {
//    init?(dictionary: [String : Any]) {
//        guard let title = dictionary["title"] as? String,
//            let description = dictionary["description"] as? String,
//            let tip = dictionary["tip"] as? String,
//            let hashtagsArray = dictionary["hashtags"] as? [String] else {return nil}
//
//        var hashtags: String = ""
//        for item in hashtagsArray {
//            hashtags += "#\(item)"
//        }
//
//        self.init(title: title, description: description, tip: tip, hashtags: hashtags, hashtagsArray: hashtagsArray)
//    }
//}
