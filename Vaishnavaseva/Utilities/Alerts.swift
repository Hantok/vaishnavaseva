import UIKit

extension UIViewController
  {
  func showErrorAlert(errorString: String)
    {
    let alert = UIAlertController(title: errorString, message: "", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
    }
  }
