//
//  DetailViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
import  SnapKit
class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var createrLbl: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var stepsLbl: UILabel!
    @IBOutlet weak var recipeIngredientsLbl: UILabel!
    @IBOutlet weak var recipeStepsLbl: UILabel!
    var realm = try! Realm()
    var recipe = Resipe()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.backgroundColor = UIColor(red: 237/255, green: 232/255, blue: 232/255, alpha: 1)
        navigationItem.title = recipe.title
        createEditBtn()
        addConstraintsToLabels()
        addConstraintsToImageView()
    }
    func addConstraintsToLabels(){
        byLabel.text = "By: "
        byLabel.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(self.view).offset(100)
            make.left.equalTo(self.view).offset(10)
        }
        createrLbl.text = recipe.creater.first!.userName
        createrLbl.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(180)
            make.height.equalTo(20)
            make.top.equalTo(self.view).offset(100)
            make.left.equalTo(self.view).offset(120)
        }
        
        recipeIngredientsLbl.text = recipe.ingredience
        recipeIngredientsLbl.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(20)
            make.top.equalTo(self.view).offset(410)
            make.left.equalTo(self.view).offset(120)
        }
        ingredientsLbl.text = "Ingredients: "
        ingredientsLbl.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(self.view).offset(410)
            make.left.equalTo(self.view).offset(10)
        }
        recipeStepsLbl.text = recipe.steps
        recipeStepsLbl.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(20)
            make.top.equalTo(self.view).offset(440)
            make.left.equalTo(self.view).offset(120)
        }
        stepsLbl.text = "Steps: "
        stepsLbl.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(self.view).offset(440)
            make.left.equalTo(self.view).offset(10)
        }
    }
    func addConstraintsToImageView(){
        if recipe.image != nil{
            imageView.image = UIImage(data: recipe.image!)
        }
        imageView.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(250)
            make.top.equalTo(self.view).offset(150)
            make.left.equalTo(self.view).offset(63)
        }
        
    }
    
    func createEditBtn(){
        editButton.layer.cornerRadius = 33
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = UIColor(colorLiteralRed: 221/255, green: 221/255, blue: 161/255, alpha: 1)
        editButton.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(66)
            make.height.equalTo(66)
            make.top.equalTo(self.view).offset(80)
            make.right.equalTo(self.view).offset(-20)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRecipe"{
            let editVC = segue.destination as! CreatingResipeViewController
            editVC.recipe = self.recipe
            
        }
    }
    
}
