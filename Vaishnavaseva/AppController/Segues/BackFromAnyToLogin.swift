//
//  FromMyToLogin.swift
//  Vaishnavaseva
//
//  Created by Roman Slysh on 11/2/15.
//  Copyright © 2015 007. All rights reserved.
//

import Foundation
//@objc(ClassName) is needed to avoid having a module name in the class name for reflection, see BaseViewController.prepareForSegue()
@objc(BackFromAnyToLogin) class BackFromAnyToLogin : BackFromAnyToAny {
  override func perform() {
    super.perform()//sets the destinationSceneController
  }
}