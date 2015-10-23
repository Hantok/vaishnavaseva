//
//  PersonalSadhanaTableViewCell.swift
//  Vaishnavaseva
//
//  Created by Roman Slysh on 9/9/15.
//  Copyright © 2015 007. All rights reserved.
//

import UIKit

class EditCountSadhanaTableViewCell: UITableViewCell {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var countTextField: UITextField!
  @IBOutlet weak var stepperControl: UIStepper!

  @IBAction func onStepperValueChanged(stepper: UIStepper) {
    countTextField.text = String("\(Int(stepper.value))")
  }

  
  //func textViewDidChange(_ textView: UITextView)
  @IBAction func onCountTextFieldEditingChanged(textField: UITextField) {
    if let value = Double((textField.text)!) {
      stepperControl.value = value
    } else {
      stepperControl.value = 0
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
