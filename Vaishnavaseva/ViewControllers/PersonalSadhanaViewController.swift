import UIKit

let userSadhanaEntriesStateViewEvent = "userSadhanaEntriesStateViewEvent"

class PersonalSadhanaViewController: BaseViewController/*, UITableViewDelegate, UITableViewDataSource*/ {
  
  var person : JSON = JSON.null

  override func viewDidLoad() {
    super.viewDidLoad()
    
    sendActionForStateViewEvent(userSadhanaEntriesStateViewEvent)
    let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
    spiningActivity.labelText = "Please wait"
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Needed for unwind segues to work
  @IBAction func backToPersonalSadhana(segue:UIStoryboardSegue)
    {
    }

}

