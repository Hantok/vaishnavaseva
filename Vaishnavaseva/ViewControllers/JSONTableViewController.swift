import UIKit
import MessageUI

class JSONTableViewController: BaseTableViewController, MFMailComposeViewControllerDelegate
  {
  var isBeforeResponseSucsess = false
  var sections: [Section] = []
  var entries: Array<SadhanaEntry> = [] {
    didSet {
      var lastDate = ""
      if sections.count != 0 {
        sections = []
      }
      for var i = 0; i < entries.count; ++i {
        let currentDate = entries[i].date!
        if lastDate != currentDate {
          lastDate = currentDate
          sections.append(Section(date: lastDate, firstIndex: i, count: 0))
        }
        ++sections[sections.count - 1].count
      }
    }
  }
  
  var year = NSCalendar.currentCalendar().components([.Year], fromDate: NSDate()).year
  var monthIndex = 0
  var dates = Dictionary<Int, NSArray>();
  var totalFound = 1
  var sadhanaUser: SadhanaUser = SadhanaUser()
  
  // MARK: Send feedback
  func sendEmail() {
    let mailComposeViewController = configuredMailComposeViewController()
    if MFMailComposeViewController.canSendMail() {
      self.presentViewController(mailComposeViewController, animated: true, completion: nil)
    } else {
      self.showSendMailErrorAlert()
    }
  }
  
  func configuredMailComposeViewController() -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
    mailComposerVC.navigationBar.viewForBaselineLayout().tintColor = UIColor.init(hexString: "81D4F7")
    
    let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!
    let appBuildNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion")!
    
    if NSUserDefaults.standardUserDefaults().valueForKey("me") != nil {
      let sadhanaUser = Deserialiser().getSadhanaUser(NSUserDefaults.standardUserDefaults().valueForKey("me") as! NSDictionary)
      mailComposerVC.setSubject("Отзыв \(sadhanaUser.userName!), версия программы: \(appVersion), номер сборки: \(appBuildNumber)")
    } else {
      mailComposerVC.setSubject("Отзыв, версия программы: \(appVersion), номер сборки: \(appBuildNumber)")
    }
    
    mailComposerVC.setToRecipients(["otzyvios@gmail.com"])
    mailComposerVC.setMessageBody("", isHTML: false)
    
    return mailComposerVC
  }
  
  func showSendMailErrorAlert() {
    let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
    sendMailErrorAlert.show()
  }
  
  // MARK: MFMailComposeViewControllerDelegate Method
  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

}
