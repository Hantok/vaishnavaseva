//
//  RootNavigationViewController.swift
//  Vaishnavaseva
//
//  Created by 007 on 7/29/15.
//  Copyright © 2015 007. All rights reserved.
//

import UIKit

class RootNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  //Next three methods are added just in case if there is some manual popping of view controller added 
    override func popViewControllerAnimated(animated: Bool) -> UIViewController?
      {
      AppController.sharedAppController.popState()
      return super.popViewControllerAnimated(animated)
      }
  
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]?
      {
      assert(false, "Never call this method please: popState() works only with one step up unwind segues")
      return super.popToViewController(viewController, animated: animated)
      }
  
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]?
      {
      assert(false, "Never call this method please: popState() works only with one step up unwind segues")
      return super.popToRootViewControllerAnimated(animated)
      }

}
