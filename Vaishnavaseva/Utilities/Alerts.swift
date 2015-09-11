import UIKit

extension UIViewController
  {
  func showErrorAlert()
    {
    let alert = UIAlertController(title: "Server error", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
    }
  }
