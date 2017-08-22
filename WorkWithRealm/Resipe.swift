//
//  Category.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import ObjectMapper

class Resipe: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var ingredience = ""
    @objc dynamic var steps = ""
    @objc dynamic var date: Date!
    @objc dynamic var image: Data?

    var creater = LinkingObjects(fromType: User.self, property: "resipe")
    func setRecipeImage(_ img: UIImage) {
        let data = UIImagePNGRepresentation(img)
        self.image = data
    }
    func getRecipeImg() -> UIImage? {
        if self.image != nil {
            let img = UIImage(data: self.image!)!
              return img
        } else {
            return nil
        }
    }

    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        ingredience <- map["ingredience"]
        steps <- map["steps"]
        date <- (map["date"], DateTransform())
       // image <- (map["image"], DataTransform()) // ?????????????????

    }

}
