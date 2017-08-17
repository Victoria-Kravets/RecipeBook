//
//  QueryToRealm.swift
//  WorkWithRealm
//
//  Created by Viktoria on 8/2/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import Foundation
import  RealmSwift
class QueryToRealm {

    func doQueryToUserInRealm() -> Results<User> {
        guard let realm = try? Realm() else { fatalError("Can not init Realm") }
        let objects = realm.objects(User.self)
        return objects
    }
    func doQueryToRecipeInRealm() -> Results<Resipe> {
        guard let realm = try? Realm() else { fatalError("Can not init Realm") }
        let objects = realm.objects(Resipe.self)
        return objects
    }
}
