//
//  DefaultRecipes.swift
//  WorkWithRealm
//
//  Created by Viktoria on 8/16/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//
import UIKit
import Foundation
import RealmSwift
import PromiseKit

class DefaultRecipes: NSObject {

    func populateDefaultResipes(recipesFromRealm: Results<Resipe>) -> Results<Resipe> {
        let query = QueryToRealm()
        var recipes = recipesFromRealm

        if recipes.count == 0 { // if count equal 0, it means that cotegory doesn't have any record
            let defaultResipes = [
                ["Chocolate Cake", "1", "1", "ChocolateCake.jpg", "Alex Gold"],
                ["Pizza", "1", "1", "pizza.jpeg", "Nikky Rush"],
                ["Gamburger", "1", "1", "gamburger.jpg", "Nick Griffin"],
                ["Spagetti", "1", "1", "spagetti.jpeg", "Olivia Woll"],
                ["Sushi", "1", "1", "sushi.jpeg", "Pamela White"]
            ] // creating default names of categories
            var count = 0
            for resipe in defaultResipes {
                // creating new instance for each recipe, fill properties adn adding object to realm
                let newResipe = Resipe()
                newResipe.id = count
                newResipe.title = resipe[0]
                newResipe.ingredience = resipe[1]
                newResipe.steps = resipe[2]
                let data = NSData(data: UIImageJPEGRepresentation(UIImage(named: resipe[3])!, 0.9)!)
                let img = UIImage(data: data as Data)
                newResipe.image = NSData(data: UIImagePNGRepresentation(img!)!) as Data
                newResipe.date = Date()
                let user = User(name: resipe[4])
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(user)
                        guard let userInDB = query.doQueryToUserInRealm()
                            .filter("userName = '\(user.userName)'").first else {
                            fatalError("Can't query userInDB")
                        }
                        addResipeToDatabase(newResipe: newResipe).then { recipe -> Void in
                            userInDB.resipe.append(recipe)
                            userInDB.countOfResipe = user.resipe.count
                            }.catch { e in
                                print(e)
                        }
                        count += 1
                    }
                } catch let e {
                        fatalError("\(e)")
                }

            recipes = query.doQueryToRecipeInRealm()

            }
        }
        return recipes

    }
     @discardableResult func addResipeToDatabase(newResipe: Resipe) -> Promise<Resipe> {
            return Promise { fulfill, reject in
                let realm = try Realm()
                do {
                    try realm.write {
                        realm.add(newResipe, update: true)
                    }
                } catch (let error) {
                    reject(error)
                }
                fulfill(newResipe)
            }
        }

}
