//
//  CreatingResipeViewController.swift
//  realm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
import AssetsLibrary.ALAssetsLibrary
import PromiseKit

class CreatingResipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let query = QueryToRealm()
    var recipe: Resipe?

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
        if let recipe = recipe {
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
    func configurePicker() {
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
                if let recipe = recipe {
                    editRecipe(recipe: recipe)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    createRecipe()
                    self.navigationController?.popViewController(animated: true)
                }
            }

            if title == "" || ingredients == "" || steps == "" || user == "" {
                createAlert(title: "Warning", massage: "Please fill all textFields!")
            }

    }

    func deleteRecipe(recipe: Resipe) {
        guard let userName = QueryToRealm.doQueryToRecipeInRealm()
            .filter("id = \(recipe.id)").first?.creater.first?.userName,
            let user = QueryToRealm.doQueryToRecipeInRealm()
                .filter("id = \(recipe.id)").first?.creater.first
            else {
            fatalError("Failed to initiate some value")
        }
        let object = QueryToRealm.doQueryToRecipeInRealm().filter("id = \(recipe.id)")
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
                user.countOfResipe = user.resipe.count
            }
        } catch let error {
            fatalError("\(error)")
        }
        JSONService.putJSONToServer(user: user)
        if let count = QueryToRealm.doQueryToUserInRealm()
            .filter("userName = '\(userName)'").first?.resipe.count, count == 0 {
            do {
                let realm = try Realm()
                try realm.write {
                    realm
                        .delete(QueryToRealm.doQueryToUserInRealm()
                            .filter("userName = '\(userName)'"))
                }
            } catch let error {
                fatalError("\(error)")
            }

            JSONService.deleteJSONFromServer(user: user)
        }

    }
    func editRecipe(recipe: Resipe) {

        let title = resipeTitle.text!
        let ingredients = resipeIngredients.text!
        let steps = resipeSteps.text!
        let userName = createrOfResipe.text!
        let currentRecipe: Resipe? = QueryToRealm.doQueryToRecipeInRealm().filter("id = \(recipe.id)").first!
        if userName != recipe.creater.first!.userName {
            deleteRecipe(recipe: recipe)
            createRecipe()
        } else {
            do {
                let realm = try Realm()
                try realm.write {
                    guard let currentRecipe = currentRecipe else {
                        fatalError("Failed due to currentRecipe")
                    }
                    currentRecipe.title = title
                    currentRecipe.ingredience = ingredients
                    currentRecipe.steps = steps
                    currentRecipe.setRecipeImage(resipeImage.image!)
                }
            } catch let error {
                fatalError("\(error)")
            }
            guard let user = QueryToRealm.doQueryToUserInRealm()
                .filter("userName = '\(userName)'").first
                else { fatalError("Failed can not fetch user") }
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
        do {
            let realm = try Realm()
            try realm.write {
                newResipe.id = QueryToRealm.doQueryToRecipeInRealm().last!.id + 1
                newResipe.title = title
                newResipe.ingredience = ingredients
                newResipe.steps = steps
                newResipe.date = NSDate() as Date!
                newResipe.setRecipeImage(resipeImage.image!)
                if isUserInDB != nil {
                    addRecipeToUser(newResipe: newResipe, isUserInDB: isUserInDB!).then { user in
                        JSONService.putJSONToServer(user: user)
                        }.catch { e in
                            fatalError("\(e)")
                    }

                } else {
                    isUserInDB = User(name: userName)
                    do {
                        let realm = try Realm()
                        realm.add(isUserInDB!)
                    } catch let error { fatalError("\(error)") }
                    let user = QueryToRealm.doQueryToUserInRealm()
                        .filter("userName = '\(isUserInDB!.userName)'").first
                    addRecipeToUser(newResipe: newResipe, isUserInDB: user!).then { user in
                        JSONService.postJSONToServer(user: user)
                        }.then {_ in
                            print("User added to server DB")
                        }.catch { e in
                            fatalError("\(e)")
                    }

                }
            }
        } catch let error {
            fatalError("\(error)")
        }
    }

    func addRecipeToUser(newResipe: Resipe, isUserInDB: User) -> Promise<User> {
        return Promise<User> { fulfill, _ in
            isUserInDB.resipe.append(newResipe)
            isUserInDB.countOfResipe = isUserInDB.resipe.count
            fulfill(isUserInDB)
        }

    }
    func createAlert(title: String, massage: String) {
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
