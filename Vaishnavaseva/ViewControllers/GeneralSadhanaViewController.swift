  import UIKit

struct Section
  {
  var date: String
  var firstIndex: Int
  var count: Int
  }

let allSadhanaEntriesStateViewEvent = "allSadhanaEntriesStateViewEvent"

class GeneralSadhanaViewController: JSONTableViewController {
  var pageNum = 0
  var itemsPerPage = 20
  var totalFound = 120
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.refreshControl = UIRefreshControl()
    
    firstTimeDownload()
    
    self.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
    self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    //self.tableView.addSubview(self.refreshControl)

    self.tableView.addInfiniteScrollingWithActionHandler(){
      self.insertRowAtBottom()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func onMySadhana(sender: AnyObject)
    {
    if AppController.sharedAppController.isLoggedIn || NSUserDefaults.standardUserDefaults().objectForKey("me") != nil
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
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return sections.count
    }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[section].count
    }
    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let greenColor = UIColor(red: 0, green: 125/256, blue: 0, alpha: 1)
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonalCell", forIndexPath: indexPath) as! GeneralSadhanaTableViewCell
        let row = sections[indexPath.section].firstIndex + indexPath.row
        if ((self.json[0])["user"])["user_name"] != nil
        {
            cell.name?.text = ((self.json[row])["user"])["user_name"].description
            if (self.json[row])["kirtan"].description == "1"
            {
                cell.kirtan?.text = "Yes"
                cell.kirtan?.textColor = greenColor
            } else
            {
                cell.kirtan?.text = "No"
                cell.kirtan?.textColor = UIColor.redColor()
            }
            cell.books?.text = (self.json[row])["reading"].description
          cell.books?.textColor = (self.json[row])["reading"].intValue > 0 ? greenColor : UIColor.redColor()
        } else
        {
            cell.name?.text = "\(row)"
        }
        cell.javaView.rounds0 = Int((self.json[row])["jcount_730"].description)!
        cell.javaView.rounds1 = Int((self.json[row])["jcount_1000"].description)!
        cell.javaView.rounds2 = Int((self.json[row])["jcount_1800"].description)!
        cell.javaView.rounds3 = Int((self.json[row])["jcount_after"].description)!

        let avatar_url = ((self.json[row])["user"])["avatar_url"].description
        if avatar_url != Constants.default_avatar_url
        {
          cell.photo.load(((self.json[row])["user"])["avatar_url"].description, placeholder: UIImage(named: "default_avatar.gif"), completionHandler: nil)
        }
        else
        {
          cell.photo.image = UIImage(named: "default_avatar.gif")
        }
        
        return cell
    }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
    let cell = tableView.dequeueReusableCellWithIdentifier("Header") as! GeneralSadhanaTableViewHeader
    cell.date.text = sections[section].date
    return cell
    }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
    return 30
    }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    performSegueWithIdentifier("GeneralToPersonal", sender: nil)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func prepareForSegue(storyboardSegue: UIStoryboardSegue, sender: AnyObject?)
  {
    super.prepareForSegue(storyboardSegue, sender: sender)
    if (storyboardSegue.identifier == "GeneralToPersonal")
    {
      let indexPath = self.tableView.indexPathForSelectedRow!
      let row = sections[indexPath.section].firstIndex + indexPath.row
      (storyboardSegue.destinationViewController as! PersonalSadhanaViewController).person = self.json[row]
    }
  }
  
  func firstTimeDownload() {
    let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
    spiningActivity.labelText = "Please wait"
    refresh(self)
  }
  
  func refresh(sender:AnyObject)
  {
    self.pageNum = 0
    sendActionForStateViewEvent(allSadhanaEntriesStateViewEvent)
    if self.tableView.infiniteScrollingView != nil
    {
      self.tableView.infiniteScrollingView.enabled = true
    }
  }
  
  func insertRowAtBottom() {
    let delayInSeconds = 2.0
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
      if (self.pageNum * self.itemsPerPage < self.totalFound - self.itemsPerPage)
      {
        if self.isBeforeResponseSucsess
        {
          ++self.pageNum
        }
      }
      else
      {
        self.tableView.infiniteScrollingView.enabled = false
      }
      self.sendActionForStateViewEvent(allSadhanaEntriesStateViewEvent)
    }
  }
}

