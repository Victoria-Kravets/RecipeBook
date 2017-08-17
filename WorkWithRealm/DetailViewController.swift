//
//  DetailViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
class DetailViewController: UIViewController {

    @IBOutlet weak var createrLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var stepsLbl: UILabel!
    var realm = try! Realm()
    var recipe = Resipe()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        titleLbl.text = recipe.title
        createrLbl.text = recipe.creater.first!.userName
        ingredientsLbl.text = recipe.ingredience
        stepsLbl.text = recipe.steps
     //   imageView.image = UIImage(data: recipe.image!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRecipe"{
            let editVC = segue.destination as! CreatingResipeViewController
            editVC.recipe = self.recipe

        }
    }

}
