//
//  CreatingResipeViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
import AssetsLibrary.ALAssetsLibrary
import PromiseKit

class CreatingResipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let realm = try! Realm()
    let query = QueryToRealm()
    var recipe: Resipe!
    
    @IBOutlet weak var createRecipeBtn: UIButton!
    @IBOutlet weak var createrOfResipe: UITextField!
    @IBOutlet weak var resipeTitle: UITextField!
    @IBOutlet weak var resipeIngredients: UITextField!
    @IBOutlet weak var resipeSteps: UITextField!
    @IBOutlet weak var resipeImage: UIImageView!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePicker()
        if recipe != nil{
            createrOfResipe.text = recipe.creater.first?.userName
            resipeTitle.text = recipe.title
            resipeIngredients.text = recipe.ingredience
            resipeSteps.text = recipe.steps
            //resipeImage.image = UIImage(data: recipe.image!)
            createRecipeBtn.setTitle("Save recipe", for: .normal)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    func configurePicker(){
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    }
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func createResipeButtonPressed(_ sender: UIButton) {
        
            let title = resipeTitle.text!
            let ingredients = resipeIngredients.text!
            let steps = resipeSteps.text!
            let user = createrOfResipe.text!
            
            if title != "" && ingredients != "" && steps != "" && user != "" {
                if recipe == nil{
                    createRecipe()
                    self.navigationController?.popViewController(animated: true)
                }else{
                    editRecipe(recipe: recipe)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
            if title == "" || ingredients == "" || steps == "" || user == "" {
                createAlert(title: "Warning", massage: "Please fill all textFields!")
            }
        
    }
    
    func deleteRecipe(recipe: Resipe){
        let object = QueryToRealm.doQueryToRecipeInRealm().filter("id = \(recipe.id)")
        let userName = QueryToRealm.doQueryToRecipeInRealm().filter("id = \(recipe.id)").first!.creater.first!.userName
        let user = QueryToRealm.doQueryToRecipeInRealm().filter("id = \(recipe.id)").first!.creater.first!
        try! realm.write {
            self.realm.delete(object)
            user.countOfResipe = user.resipe.count
        }
        JSONService.putJSONToServer(user: user)
        if QueryToRealm.doQueryToUserInRealm().filter("userName = '\(userName)'").first!.resipe.count == 0 {
            try! realm.write {
                self.realm.delete(QueryToRealm.doQueryToUserInRealm().filter("userName = '\(userName)'"))
            }
            JSONService.deleteJSONFromServer(user: user)
        }
        
    }
    func editRecipe(recipe: Resipe){
        
        let title = resipeTitle.text!
        let ingredients = resipeIngredients.text!
        let steps = resipeSteps.text!
        let userName = createrOfResipe.text!
        let currentRecipe: Resipe? = QueryToRealm.doQueryToRecipeInRealm().filter("id = \(recipe.id)").first!
        
            if userName != recipe.creater.first!.userName{
                deleteRecipe(recipe: recipe)
                createRecipe()

            }else{
                try! realm.write {
                    currentRecipe?.title = title
                    currentRecipe?.ingredience = ingredients
                    currentRecipe?.steps = steps
                    currentRecipe?.setRecipeImage(resipeImage.image!)
                }
                let user = QueryToRealm.doQueryToUserInRealm().filter("userName = '\(userName)'").first!
                JSONService.putJSONToServer(user: user)
            }
            
        
    }

    func createRecipe() {
        let newResipe = Resipe()
        let title = resipeTitle.text!
        let ingredients = resipeIngredients.text!
        let steps = resipeSteps.text!
        let userName = createrOfResipe.text!
        var isUserInDB = QueryToRealm.doQueryToUserInRealm().filter("userName = '\(userName)'").first
        try! realm.write(){
            if let last = QueryToRealm.doQueryToRecipeInRealm().last {
                newResipe.id = last.id + 1
            } else {
                newResipe.id = 1
            }
            newResipe.title = title
            newResipe.ingredience = ingredients
            newResipe.steps = steps
            newResipe.date = NSDate() as Date!
            newResipe.setRecipeImage(resipeImage.image!)
            let jsonConverter = JSONService()
            if isUserInDB != nil {
                addRecipeToUser(newResipe: newResipe, isUserInDB: isUserInDB!).then{user in
                    JSONService.putJSONToServer(user: user)
                    }
                
            }else{
                isUserInDB = User(name: userName)
                self.realm.add(isUserInDB!)
                let user = QueryToRealm.doQueryToUserInRealm().filter("userName = '\(isUserInDB!.userName)'").first
                
                
                addRecipeToUser(newResipe: newResipe, isUserInDB: user!).then{ user in
                    JSONService.postJSONToServer(user: user)
                    }.then{_ in
                        print("User added to server DB")
                }

            }
        }
    }
    
    func addRecipeToUser(newResipe: Resipe, isUserInDB: User) -> Promise<User>{
        return Promise<User> { fulfill, reject in
            isUserInDB.resipe.append(newResipe)
            isUserInDB.countOfResipe = isUserInDB.resipe.count
            fulfill(isUserInDB)
        }
        
    }
    func createAlert(title: String, massage: String){
        let alert = UIAlertController(title: title, message: massage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        resipeImage.image = image!
        self.dismiss(animated: true, completion: nil)
    }
}







