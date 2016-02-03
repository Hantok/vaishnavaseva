import UIKit

let userSadhanaEntriesStateViewEvent = "userSadhanaEntriesStateViewEvent"

class PersonalSadhanaViewController: JSONTableViewController {
  
  var sadhanaUser: SadhanaUser = SadhanaUser()
  var totalFound = 1
  
  var year = 0
  var monthIndex = 0
  var dates = Dictionary<Int, NSArray>();
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let components = NSCalendar.currentCalendar().components([.Year], fromDate: NSDate())
    self.year = components.year
    sendActionForStateViewEvent(userSadhanaEntriesStateViewEvent)
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
    spiningActivity.labelText = NSLocalizedString("Please wait", comment: "Activity indicator text")

    self.tableView.addInfiniteScrollingWithActionHandler()
    {
      self.insertRowAtBottom()
    }
    self.tableView.allowsSelection = false
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Needed for unwind segues to work
  @IBAction func backToPersonalSadhana(segue:UIStoryboardSegue)
  {
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return entries.count
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
    
    return cell
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("Header") as! PersonalSadhanaTableHeader
    cell.name.text = sadhanaUser.userName
    
    let avatar_url = sadhanaUser.avatarUrl!
    if avatar_url != Constants.default_avatar_url
    {
      if (Manager.sharedInstance.cache[NSURL(string: avatar_url)!] != nil) {
        cell.photo.image = Manager.sharedInstance.cache[NSURL(string: avatar_url)!]
      }
      else {
        cell.photo.load(avatar_url, placeholder: UIImage(named: "default_avatar.gif"), completionHandler: nil)
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
          self.sendActionForStateViewEvent(userSadhanaEntriesStateViewEvent)
      }
    }
    else
    {
      self.tableView.infiniteScrollingView.stopAnimating()
      self.tableView.infiniteScrollingView.enabled = false
    }
  }
}

