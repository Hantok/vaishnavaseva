import UIKit

@objc class AppControllerStateEditSadhana: AppControllerState
  {
  override func sceneDidBecomeCurrent()
    {
    super.sceneDidBecomeCurrent()
    self.viewController.setAction(Selector("onDone"), forTarget: self, forStateViewEvent: OnDoneStateViewEvent)
    }

  func onDone()
    {
    //TODO:
    //Here:
    // - Show activity indicator
    // - Show network activity indicator
    // - Try to write data to server in a separate queue.
    //On response:
    // - Hide both indicators
    // - performSegueWithIdentifier("BackFromAnyToAny", sender: nil)
    //On error:
    // - Hide both indicators
    // - Report an error
    viewController.performSegueWithIdentifier("BackFromAnyToAny", sender: nil)
    }
  

//  override func isEqualTo(other: EquatableBase) -> Bool
//    {
//    let otherDynamic = other as! AppControllerStateSecond
//    return  super.isEqualTo(other) &&
//            self.state == otherDynamic.state
//    }
  }
