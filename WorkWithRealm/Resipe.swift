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
class Resipe : Object {
    
    dynamic var id = UUID().uuidString
    dynamic var title = ""
    dynamic var ingredience = ""
    dynamic var steps = ""
    dynamic var date : Date!
    dynamic var image : Data?
    dynamic var recipeId: String {
        return "\(id)"
    }
    var creater = LinkingObjects(fromType: User.self, property: "resipe")
    func setRecipeImage(_ img: UIImage) {
        let data = UIImagePNGRepresentation(img)
        self.image = data
    }
    func getRecipeImg() -> UIImage? {
        if self.image != nil{
            let img = UIImage(data: self.image!)!
            return img
        }
        else {
            return nil
        }
    }
    override static func primaryKey() -> String? {
        return "id"
    }

    
}
