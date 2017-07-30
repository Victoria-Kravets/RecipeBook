//
//  ResipeTableViewCell.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit

class ResipeTableViewCell: UITableViewCell {

    @IBOutlet weak var resipeImage: UIImageView!
    @IBOutlet weak var resipeTitle: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
   
    func configureCell(resipe: Resipe){
        resipeTitle.text = resipe.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.string(from: resipe.date!)
        print(date)
        dateLbl.text = date
        resipeImage.image = resipe.getRecipeImg()
    }

}