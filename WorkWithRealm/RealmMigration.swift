//
//  RealmMigration.swift
//  WorkWithRealm
//
//  Created by Viktoria on 8/22/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMigration{
    
    let config = Realm.Configuration(
        schemaVersion: 2,
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 2) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
    })
    
}
