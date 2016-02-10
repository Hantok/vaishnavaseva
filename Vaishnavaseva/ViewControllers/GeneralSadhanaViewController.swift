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
  var needToUpdateRefreshToken = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.refreshControl = UIRefreshControl()
    
    firstTimeDownload()
    
    self.refreshControl?.attributedTitle = NSAttributedString(string: NSLocalizedString("Refreshing...", comment: "Refresh control text"))
    self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

    self.tableView.addInfiniteScrollingWithActionHandler(){
      self.insertRowAtBottom()
    }
  }
  
  func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
    if needToUpdateRefreshToken && !AppController.sharedAppController.isLoggedIn {
      needToUpdateRefreshToken = false
      onMySadhana(self)
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
  @IBAction func backToGeneralSadhana(segue:UIStoryboardSegue) {
    if segue.identifier! == "BackFromAnyToLogin" {
      needToUpdateRefreshToken = true
      AppController.sharedAppController.isLoggedIn = false
      NSUserDefaults.standardUserDefaults().removeObjectForKey("me")
    }
  }
  @IBAction func feedbackPressed(sender: AnyObject) {
    self.sendEmail();
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
      let sadhanaEntry = entries[row]
      
      cell.name?.text = sadhanaEntry.sadhanaUser?.userName
      if (sadhanaEntry.kirtan != false) {
        cell.kirtan?.text = NSLocalizedString("Yes", comment: "Kirtan done")
        cell.kirtan?.textColor = greenColor
      } else {
        cell.kirtan?.text = NSLocalizedString("No", comment: "No kirtan done")
        cell.kirtan?.textColor = UIColor.redColor()
      }
      cell.books?.text = sadhanaEntry.reading?.description
      cell.books?.textColor = sadhanaEntry.reading > 0 ? greenColor : UIColor.redColor()
      cell.javaView.rounds0 = sadhanaEntry.jCount730!
      cell.javaView.rounds1 = sadhanaEntry.jCount1000!
      cell.javaView.rounds2 = sadhanaEntry.jCount1800!
      cell.javaView.rounds3 = sadhanaEntry.jCountAfter!
      
      let avatar_url = sadhanaEntry.sadhanaUser?.avatarUrl!
      if avatar_url != Constants.default_avatar_url
      {
        cell.photo.load(avatar_url!, placeholder: UIImage(named: "default_avatar.gif"), completionHandler: nil)
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
    let me = NSUserDefaults.standardUserDefaults().objectForKey("me")
    let i = sections[indexPath.section].firstIndex + indexPath.row
    if me != nil && (me as! NSDictionary).objectForKey("userid")?.integerValue == self.entries[i].sadhanaUser?.userId {
      performSegueWithIdentifier("GeneralToMy", sender: nil)
    } else {
      performSegueWithIdentifier("GeneralToPersonal", sender: nil)
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func prepareForSegue(storyboardSegue: UIStoryboardSegue, sender: AnyObject?)
  {
    super.prepareForSegue(storyboardSegue, sender: sender)
    if (storyboardSegue.identifier == "GeneralToPersonal")
    {
      let indexPath = self.tableView.indexPathForSelectedRow!
      let row = sections[indexPath.section].firstIndex + indexPath.row
      (storyboardSegue.destinationViewController as! PersonalSadhanaViewController).sadhanaUser = self.entries[row].sadhanaUser!
    }
  }
  
  func firstTimeDownload() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
    spiningActivity.labelText = NSLocalizedString("Please wait", comment: "Activity indicator text")
    refresh(self)
  }
  
  func refresh(sender:AnyObject)
  {
    self.pageNum = 0
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    sendActionForStateViewEvent(allSadhanaEntriesStateViewEvent)
    if self.tableView.infiniteScrollingView != nil
    {
      self.tableView.infiniteScrollingView.enabled = true
    }
  }
  
  func insertRowAtBottom() {
    dispatch_async(dispatch_get_main_queue()) {
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
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      self.sendActionForStateViewEvent(allSadhanaEntriesStateViewEvent)
    }
  }
}

