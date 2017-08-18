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

class DefaultRecipes{
    
    let realm = try! Realm()
    
    func populateDefaultResipes(recipesFromRealm: Results<Resipe>) -> Results<Resipe> {
        var recipes = recipesFromRealm
        if recipes.count == 0 { // if count equal 0, it means that cotegory doesn't have any record
            
            let defaultResipes = [["Chocolate Cake", "1", "1", "ChocolateCake.jpg", "Alex Gold"], ["Pizza", "1", "1", "pizza.jpeg","Nikky Rush"], ["Gamburger", "1", "1", "gamburger.jpg", "Nick Griffin"], ["Spagetti", "1", "1", "spagetti.jpeg", "Olivia Woll"], ["Sushi", "1", "1", "sushi.jpeg", "Pamela White"]] // creating default names of categories
            var count = 0
            for resipe in defaultResipes { // creating new instance for each recipe, fill properties adn adding object to realm
                
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
                
                try! realm.write {
                    realm.add(user)
                    let userInDB = QueryToRealm.doQueryToUserInRealm().filter("userName = '\(user.userName)'").first
                    addResipeToDatabase(newResipe: newResipe).then{ recipe in
                        userInDB?.resipe.append(recipe)
                        }
                    userInDB?.countOfResipe = user.resipe.count
                }
                count += 1
            }
            recipes = QueryToRealm.doQueryToRecipeInRealm()
            
        }
        return recipes
    }
        func addResipeToDatabase(newResipe: Resipe) -> Promise<Resipe> {
            return Promise { fulfill, reject in
                try! realm.write(){
                    realm.add(newResipe)
                    fulfill(newResipe)
                }
            }
        }
    
}
