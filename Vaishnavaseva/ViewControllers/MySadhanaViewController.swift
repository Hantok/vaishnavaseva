import UIKit

class MySadhanaViewController: JSONTableViewController {
  let mySadhanaEntriesStateViewEvent = "mySadhanaEntriesStateViewEvent"
  
  var me: JSON = JSON.null
  var month = 0
  var totalFound = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "My sadhana"
    if me == nil {
      self.me = JSON.init(NSUserDefaults.standardUserDefaults().valueForKey("me")!)
    }
    sendActionForStateViewEvent(mySadhanaEntriesStateViewEvent)
    let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
    spiningActivity.labelText = "Please wait"
    
    self.tableView.addInfiniteScrollingWithActionHandler()
      {
        self.insertRowAtBottom()
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
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.json.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let greenColor = UIColor(red: 0, green: 125/256, blue: 0, alpha: 1)
    let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! PersonalSadhanaTableViewCell
    let row = indexPath.row
    if (self.json[row])["kirtan"].description == "1"
    {
      cell.kirtan?.text = "Yes"
      cell.kirtan?.textColor = greenColor
    } else
    {
      cell.kirtan?.text = "No"
      cell.kirtan?.textColor = UIColor.redColor()
    }
    cell.date.text = (self.json[row])["date"].description
    cell.books?.text = (self.json[row])["reading"].description
    cell.books?.textColor = (self.json[row])["reading"].intValue > 0 ? greenColor : UIColor.redColor()
    
    cell.javaView.rounds0 = Int((self.json[row])["jcount_730"].description)!
    cell.javaView.rounds1 = Int((self.json[row])["jcount_1000"].description)!
    cell.javaView.rounds2 = Int((self.json[row])["jcount_1800"].description)!
    cell.javaView.rounds3 = Int((self.json[row])["jcount_after"].description)!
    
    return cell
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("Header") as! PersonalSadhanaTableHeader
    cell.name.text = me["user_name"].stringValue
    
    let avatar_url = me["avatar_url"].description
    if avatar_url != Constants.default_avatar_url
    {
      if (Manager.sharedInstance.cache[NSURL(string: avatar_url)!] != nil) {
        cell.photo.image = Manager.sharedInstance.cache[NSURL(string: avatar_url)!]
      }
      else {
        cell.photo.load(me["avatar_url"].description, placeholder: UIImage(named: "default_avatar.gif"), completionHandler: nil)
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
      let delayInSeconds = 2.0
      let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
      
      dispatch_after(popTime, dispatch_get_main_queue())
        {
          // decrease date if previous request was success
          if self.isBeforeResponseSucsess
          {
            --self.month 
          }
          self.sendActionForStateViewEvent(self.mySadhanaEntriesStateViewEvent)
      }
    }
    else
    {
      self.tableView.infiniteScrollingView.stopAnimating()
      self.tableView.infiniteScrollingView.enabled = false
    }
  }
  
  @IBAction func onEdit(sender: AnyObject)
    {
    performSegueWithIdentifier("MyToEdit", sender: nil)
    }
  
  //Needed for unwind segues to work
  @IBAction func backToMySadhana(segue:UIStoryboardSegue)
    {
    }
}

