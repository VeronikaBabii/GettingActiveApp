////
////  Sweet.swift
////  GettingActiveApp
////
////  Created by Veronika Babii on 06.06.2020.
////  Copyright © 2020 GettingActiveApp. All rights reserved.
////
//
//import Foundation
//import FirebaseFirestore
//
//protocol DocumentSerializable  {
//    init?(dictionary:[String:Any])
//}
//
//struct Sweet {
//    var name:String
//    var hashtags:String
//    var timeStamp:String
//
//    var dictionary:[String:Any] {
//        return [
//            "name":name,
//            "hashtags" : hashtags,
//            "timeStamp" : timeStamp
//        ]
//    }
//}
//
//extension Sweet : DocumentSerializable {
//    init?(dictionary: [String : Any]) {
//        let name = dictionary["name"] as? String ?? "Error! Name Field Not Found!"
//        let hashtags = dictionary["hashtags"] as? String ?? "Error! Hashtags Field Not Found!"
//        let timeStamp = dictionary["timeStamp"] as? String ?? "Error! TimeStamp Field Not Found!"
//
//        self.init(name: name, hashtags: hashtags, timeStamp: timeStamp)
//    }
//}
