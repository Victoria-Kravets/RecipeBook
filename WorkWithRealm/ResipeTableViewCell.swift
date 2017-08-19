//
//  ResipeTableViewCell.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift

class ResipeTableViewCell: UITableViewCell {

    @IBOutlet weak var resipeImage: UIImageView!
    @IBOutlet weak var resipeTitle: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var createrLbl: UILabel!

    func configureCell(resipe: Resipe) {
        resipeTitle.text = resipe.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.string(from: resipe.date!)

        dateLbl.text = date
        resipeImage.image = resipe.getRecipeImg()
        let nameOfChef = QueryToRealm.doQueryToRecipeInRealm()
            .filter("id = \(resipe.id)").first!.creater.first!.userName
        createrLbl.text = "by: " + nameOfChef
    }

}
