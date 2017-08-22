//
//  UserTableViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/30/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
class UserTableViewController: UITableViewController {
    var user: User!
    var arrayOfChefs = [User]()
    var chefsWithRecipe = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        var count = 0
        let users = QueryToRealm.doQueryToUserInRealm()
        for user in users {

            if arrayOfChefs.count != 0 {
                for chef in arrayOfChefs where chef.userName == user.userName {
                    arrayOfChefs.remove(at: arrayOfChefs.index(of: chef)!)
                    count -= 1
                }
                arrayOfChefs.append(user)
                count += 1
            } else {
                arrayOfChefs.append(user)
            }
        }
        getChefsWithRecipes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chefsWithRecipe.count
    }
    func getChefsWithRecipes(){
        for chef in arrayOfChefs{
            if chef.countOfResipe > 0{
                chefsWithRecipe.append(chef)
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell {
            cell.userNameLbl.text = chefsWithRecipe[indexPath.row].userName
            if chefsWithRecipe[indexPath.row].countOfResipe == 1 {
                cell.countOfResipe.text = String(chefsWithRecipe[indexPath.row].countOfResipe) + " resipe"
            } else if chefsWithRecipe[indexPath.row].countOfResipe >= 1 {
                cell.countOfResipe.text = String(chefsWithRecipe[indexPath.row].countOfResipe) + " resipes"
            }
            return cell
        }
        return UITableViewCell()

    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        user = QueryToRealm.doQueryToRecipeInRealm()[indexPath.row].creater.first
        print(user)
        return indexPath
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "See recipes of selected chef"{
            guard let tableResipesOfOneChef = segue.destination as?
                MyTableViewController
                else { fatalError("Failed to get value for tableResipesOfOneChef") }
            tableResipesOfOneChef.chef = user.userName
        }

    }

}
