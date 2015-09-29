//
//  PersonalSadhanaTableViewCell.swift
//  Vaishnavaseva
//
//  Created by Roman Slysh on 9/9/15.
//  Copyright © 2015 007. All rights reserved.
//

import UIKit

class PersonalSadhanaTableViewCell: UITableViewCell {
  
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var kirtan: UILabel!
  @IBOutlet weak var books: UILabel!
  @IBOutlet weak var javaView: JapaView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
