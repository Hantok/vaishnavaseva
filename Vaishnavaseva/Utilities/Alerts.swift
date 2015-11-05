import UIKit

extension UIViewController
  {
  func showErrorAlert(errorString: String)
    {
    let alert = UIAlertController(title: errorString, message: NSLocalizedString("", comment: "Alert message (no text)"), preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
    }
  }
