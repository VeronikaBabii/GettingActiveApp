////
////  Sweet.swift
////  GettingActiveApp
////
////  Created by Veronika Babii on 01.06.2020.
////  Copyright © 2020 Veronika Babii. All rights reserved.
////
//
//import Foundation
//import FirebaseFirestore
//
//// protocol that lets to initialize struct
//protocol DocumentSerializable {
//    init?(dictionary:[String:Any])
//}
//
//struct Sweet {
//    var name: String
//    var content: String
//
//    // encode information into JSON using dictionary
//    var dictionary:[String:Any] {
//        return [
//            "name": name,
//            "content": content
//        ]
//    }
//}
//
//extension Sweet:DocumentSerializable {
//
//    init?(dictionary: [String : Any]) {
//
//        // get name and cast it to String
//
//            let name = dictionary["name"] as? String ?? "Name Field Not Found!"
//            let content = dictionary["content"] as? String ?? "Content Field Not Found!"
//
//        // if it works
//        self.init(name: name, content: content)
//    }
//}
//
////struct Sweet {
////    var name: String
////    var content: String
////    var timeStamp: Date
////
////    // encode information into JSON using dictionary
////    var dictionary:[String:Any] {
////        return [
////            "name": name,
////            "content": content,
////            "timeStamp": timeStamp
////        ]
////    }
////}
////
////extension Sweet:DocumentSerializable {
////    init?(dictionary: [String : Any]) {
////
////        // get name and cast it to String
////
////        guard let name = dictionary["name"] as? String,
////            let content = dictionary["content"] as? String,
////            let timeStamp = dictionary["timeStamp"] as? Date else {return nil}
////
////        // if it works
////        self.init(name: name, content: content, timeStamp: timeStamp)
////    }
////}
