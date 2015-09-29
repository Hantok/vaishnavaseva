//
//  PersonalSadhanaTableHeader.swift
//  Vaishnavaseva
//
//  Created by Roman Slysh on 9/29/15.
//  Copyright © 2015 007. All rights reserved.
//

import UIKit

class PersonalSadhanaTableHeader: UITableViewCell {
  
  @IBOutlet weak var photo: UIImageView!
  @IBOutlet weak var name: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}