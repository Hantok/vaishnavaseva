import UIKit

let mySadhanaEntriesStateViewEvent = "mySadhanaEntriesStateViewEvent"
let updateAceessTokenStateViewEvent = "updateAceessTokenStateViewEvent"

class MySadhanaViewController: JSONTableViewController {
  var selectedSadhanaEntry : SadhanaEntry?
  var selectedPath : NSIndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.leftItemsSupplementBackButton = true;
    if self.sadhanaUser.userName == nil {
      self.sadhanaUser = Deserialiser().getSadhanaUser(NSUserDefaults.standardUserDefaults().valueForKey("me") as! NSDictionary)
    }
    sendActionForStateViewEvent(mySadhanaEntriesStateViewEvent)
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
    spiningActivity.labelText = NSLocalizedString("Please wait", comment: "Activity indicator text")
    
    self.tableView.addInfiniteScrollingWithActionHandler() {
        self.insertRowAtBottom()
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    let curDate = NSDate().timeIntervalSince1970
    if NSUserDefaults.standardUserDefaults().objectForKey("lastDate") == nil || curDate - NSUserDefaults.standardUserDefaults().objectForKey("lastDate")!.doubleValue > 86400 {
      sendActionForStateViewEvent(updateAceessTokenStateViewEvent)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Needed for unwind segues to work
  @IBAction func backToPersonalSadhana(segue:UIStoryboardSegue)
  {
  }
  @IBAction func feedbackPressed(sender: AnyObject) {
    self.sendEmail()
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.entries.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let greenColor = UIColor(red: 0, green: 125/256, blue: 0, alpha: 1)
    let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! PersonalSadhanaTableViewCell
    let sadhanaEntry = entries[indexPath.row]
    if sadhanaEntry.kirtan == true
    {
      cell.kirtan?.text = NSLocalizedString("Yes", comment: "Kirtan done")
      cell.kirtan?.textColor = greenColor
    } else
    {
      cell.kirtan?.text = NSLocalizedString("No", comment: "No kirtan done")
      cell.kirtan?.textColor = UIColor.redColor()
    }
    cell.date.text = sadhanaEntry.date!
    cell.books?.text = sadhanaEntry.reading?.description
    cell.books?.textColor = sadhanaEntry.reading! > 0 ? greenColor : UIColor.redColor()
    
    cell.javaView.rounds0 = sadhanaEntry.jCount730!
    cell.javaView.rounds1 = sadhanaEntry.jCount1000!
    cell.javaView.rounds2 = sadhanaEntry.jCount1800!
    cell.javaView.rounds3 = sadhanaEntry.jCountAfter!
    
    cell.javaView.countLabel.text = "\(sadhanaEntry.jCount730! + sadhanaEntry.jCount1000! + sadhanaEntry.jCount1800! + sadhanaEntry.jCountAfter!)"
    
    return cell
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("Header") as! PersonalSadhanaTableHeader
    cell.name.text = sadhanaUser.userName!
    
    if sadhanaUser.avatarUrl != Constants.default_avatar_url
    {
      if (Manager.sharedInstance.cache[NSURL(string: sadhanaUser.avatarUrl!)!] != nil) {
        cell.photo.image = Manager.sharedInstance.cache[NSURL(string: sadhanaUser.avatarUrl!)!]
      }
      else {
        cell.photo.load(sadhanaUser.avatarUrl!, placeholder: UIImage(named: "default_avatar.gif"), completionHandler: nil)
      }
    }
    else
    {
      cell.photo.image = UIImage(named: "default_avatar.gif")
    }

    return cell
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    return 87
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.selectedSadhanaEntry = entries[indexPath.row]
    self.selectedPath = indexPath
    performSegueWithIdentifier("MyToEdit", sender: nil)
  }
  
  func insertRowAtBottom()
  {
    if totalFound != 0
    {
      dispatch_async(dispatch_get_main_queue())
        {
          // decrease date if previous request was success
          if self.isBeforeResponseSucsess
          {
            ++self.monthIndex
          }
          UIApplication.sharedApplication().networkActivityIndicatorVisible = true
          self.sendActionForStateViewEvent(mySadhanaEntriesStateViewEvent)
      }
    }
    else
    {
      self.tableView.infiniteScrollingView.stopAnimating()
      self.tableView.infiniteScrollingView.enabled = false
    }
  }
  
  //Needed for unwind segues to work
  @IBAction func backToMySadhana(segue:UIStoryboardSegue)
    {
    }
}

