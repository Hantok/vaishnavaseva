//
//  BackFromEditToMy.swift
//  Vaishnavaseva
//
//  Created by Roman Slysh on 11/2/15.
//  Copyright © 2015 007. All rights reserved.
//

import Foundation
//@objc(ClassName) is needed to avoid having a module name in the class name for reflection, see BaseViewController.prepareForSegue()
@objc(BackFromEditToMy) class BackFromEditToMy : BackFromAnyToAny
{
  override func perform()
  {
    super.perform()//sets the destinationSceneController
//    self.destinationSceneController.viewController = self.visualSegue.destinationViewController
    
    //Transfer any data between AppControllerStates and ViewControllers here
    let mySadhanaViewController = (self.destinationSceneController.viewController as! MySadhanaViewController)
    mySadhanaViewController.selectedSadhanaEntry = (self.sourceSceneController.viewController as! EditSadhanaViewController).sadhanaEntry
    
    //updete SadhanaEntry in table view
    mySadhanaViewController.entries[(mySadhanaViewController.selectedPath?.row)!] = mySadhanaViewController.selectedSadhanaEntry!
    mySadhanaViewController.tableView.reloadRowsAtIndexPaths([mySadhanaViewController.selectedPath!], withRowAnimation: UITableViewRowAnimation.Fade)
  }
}
