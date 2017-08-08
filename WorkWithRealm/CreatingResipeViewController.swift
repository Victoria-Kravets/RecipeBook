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
    
    @IBOutlet weak var createrOfResipe: UITextField!
    @IBOutlet weak var resipeTitle: UITextField!
    @IBOutlet weak var resipeIngredients: UITextField!
    @IBOutlet weak var resipeSteps: UITextField!
    @IBOutlet weak var resipeImage: UIImageView!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePicker()
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
            let newResipe = Resipe()
            
            createRecipe(newResipe: newResipe)
            
            //addRecipeToUser(newResipe: newResipe, isUserInDB: user)
            
            self.navigationController?.popViewController(animated: true)
        }
        
        if title == "" || ingredients == "" || steps == "" || user == "" {
            createAlert(title: "Warning", massage: "Please fill all textFields!")
        }
    }
    func createRecipe(newResipe: Resipe) -> User {
        let title = resipeTitle.text!
        let ingredients = resipeIngredients.text!
        let steps = resipeSteps.text!
        let userName = createrOfResipe.text!
        var isUserInDB = self.query.doQueryToUserInRealm().filter("userName = '\(userName)'").first
        
        try! realm.write(){
            if isUserInDB != nil {
                newResipe.creater = isUserInDB
            }else{
                isUserInDB = User(name: userName)
                newResipe.creater = isUserInDB
            }
            newResipe.title = title
            newResipe.ingredience = ingredients
            newResipe.steps = steps
            newResipe.date = NSDate() as Date!
            newResipe.setRecipeImage(resipeImage.image!)
            addResipeToDatabase(newResipe: newResipe).then{ recipe in
                self.addRecipeToUser(newResipe: recipe, isUserInDB: isUserInDB!)
                }.catch {error in
                    print(error)
            }
            
        }
        return isUserInDB!
    }
    func addResipeToDatabase(newResipe: Resipe) -> Promise<Resipe> {
        return Promise { fulfill, reject in
            self.realm.add(newResipe)
            fulfill(newResipe)
        }
    }
    
    func addRecipeToUser(newResipe: Resipe, isUserInDB: User){
        try!realm.write {
            isUserInDB.resipe.append(newResipe)
        }
    }
    func createAlert(title: String, massage: String){
        let alert = UIAlertController(title: title, message: massage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        resipeImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
