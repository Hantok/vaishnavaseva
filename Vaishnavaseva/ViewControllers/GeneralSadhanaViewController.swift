import UIKit

class GeneralSadhanaViewController: BaseViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func onMySadhana(sender: AnyObject)
    {
    if AppController.sharedAppController.isLoggedIn
      {
      performSegueWithIdentifier("GeneralToMy", sender: nil)
      }
    else
      {
      performSegueWithIdentifier("GeneralToLogIn", sender: nil)
      }
    }
  
  @IBAction func onAnyRecordSelected(sender: AnyObject)
    {
    performSegueWithIdentifier("GeneralToPersonal", sender: nil)
    }
  
  @IBAction func backToGeneralSadhana(segue:UIStoryboardSegue)
    {
    }

}

