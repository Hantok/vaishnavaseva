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
  
    override func popViewControllerAnimated(animated: Bool) -> UIViewController?
      {
      AppController.sharedAppController.pop()
      return super.popViewControllerAnimated(animated)
      }
  
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]?
      {
      assert(false, "Never call this method please: pop() works only with one step up unwind segues")
      return super.popToViewController(viewController, animated: animated)
      }
  
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]?
      {
      assert(false, "Never call this method please: pop() works only with one step up unwind segues")
      return super.popToRootViewControllerAnimated(animated)
      }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
