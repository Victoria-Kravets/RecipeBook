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

    let realm = try! Realm()
    var user: User!
    let query = QueryToRealm()
    var arrayOfChefs = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        var count = 0
        let users = self.query.doQueryToUserInRealm()
        for user in users {

            if arrayOfChefs.count != 0 {
                for chef in arrayOfChefs {
                    if chef.userName == user.userName {
                        arrayOfChefs.remove(at: arrayOfChefs.index(of: chef)!)
                        count -= 1
                    }
                }
                arrayOfChefs.append(user)
                count += 1
            } else {
                arrayOfChefs.append(user)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfChefs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell {
            cell.userNameLbl.text = arrayOfChefs[indexPath.row].userName
            if arrayOfChefs[indexPath.row].countOfResipe == 1 {
                cell.countOfResipe.text = String(arrayOfChefs[indexPath.row].countOfResipe) + " resipe"
            } else if arrayOfChefs[indexPath.row].countOfResipe >= 1 {
                cell.countOfResipe.text = String(arrayOfChefs[indexPath.row].countOfResipe) + " resipes"
            }
            return cell
        }
        return UITableViewCell()

    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        user = self.query.doQueryToRecipeInRealm()[indexPath.row].creater.first
        return indexPath
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "See recipes of selected chef"{
            let tableResipesOfOneChef = segue.destination as! MyTableViewController
            tableResipesOfOneChef.chef = user.userName
        }

    }

}
