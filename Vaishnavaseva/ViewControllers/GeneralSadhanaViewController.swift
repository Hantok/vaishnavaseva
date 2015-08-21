import UIKit

class GeneralSadhanaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var tableView: UITableView!
  
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
  
  //Needed for unwind segues to work
  @IBAction func backToGeneralSadhana(segue:UIStoryboardSegue)
    {
    }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
    return 1
    }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    return 1
    }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
    let cell = tableView.dequeueReusableCellWithIdentifier("PersonalCell", forIndexPath: indexPath) as UITableViewCell
    return cell
    }
}

