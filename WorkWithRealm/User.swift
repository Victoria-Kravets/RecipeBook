//
//  User.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/30/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class User: Object, Mappable {
    dynamic var userName = ""
    var count = 0
    var resipe = List<Resipe>()
    dynamic var countOfResipe : Int{
        get{
            count = resipe.count
            return count
        }
        set{
            count = newValue
        }
        
        
    }
    convenience init(name: String){
        self.init()
        self.userName = name
    }
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        userName <- map["userName"]
        resipe <- (map["resipe"], ListTransform<Resipe>())
        countOfResipe <- map["countOfResipe"]
    }
    
}
