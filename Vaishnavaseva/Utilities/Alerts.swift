import UIKit

extension UIViewController {
  func showErrorAlert(errorString: String) {
    if #available(iOS 8.0, *) {
      let alert = UIAlertController(title: errorString, message: NSLocalizedString("", comment: "Alert message (no text)"), preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
    } else {
      // Fallback on earlier versions
      //need to check code below
      //let alertView = UIAlertView(title: errorString, message: NSLocalizedString("", comment: "Alert message (no text)"), delegate: self, cancelButtonTitle: NSLocalizedString("OK", comment: "Alert OK button"))
      //alertView.show()
    }
  }
}
