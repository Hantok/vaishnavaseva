import UIKit

class PersonalSettingsViewController: BaseViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  @IBAction func onDone(sender: AnyObject) {
    self.performSegueWithIdentifier("BackFromAnyToAny", sender: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

