//
//  CreatingResipeViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
class CreatingResipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var createrOfResipe: UITextField!
    @IBOutlet weak var resipeTitle: UITextField!
    @IBOutlet weak var resipeIngredients: UITextField!
    @IBOutlet weak var resipeSteps: UITextField!
    @IBOutlet weak var resipeImage: UIImageView!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
   
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func createResipeButtonPressed(_ sender: UIButton) {
        let title = resipeTitle.text!
        let ingredients = resipeIngredients.text!
        let steps = resipeSteps.text!
        let user = createrOfResipe.text!
        if title != "" && ingredients != "" && steps != "" && user != "" {
           
            try! realm.write(){
                let a = try! Realm().objects(User)
                let b = try! Realm().objects(Resipe)
                print(a)
                print(b)
                let newResipe = Resipe()
                
//                let isUserInDB = realm.objects(User).filter("userName = '1'").first
//                print(isUserInDB)
//                if isUserInDB != nil {
//                    newResipe.creater = isUserInDB
//
//                }else{
//                    newResipe.creater = User(name: createrOfResipe.text!)
//
//                }
                newResipe.creater = User(name: createrOfResipe.text!)

                newResipe.title = title
                newResipe.ingredience = ingredients
                newResipe.steps = steps
                newResipe.date = NSDate() as Date!
                newResipe.setRecipeImage(resipeImage.image!)
                self.realm.add(newResipe)
                print(newResipe)
            }
            self.navigationController?.popViewController(animated: true)
        }
        if title == "" || ingredients == "" || steps == "" || user == "" {
            createAlert(title: "Warning", massage: "Please fill all textFields!")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
