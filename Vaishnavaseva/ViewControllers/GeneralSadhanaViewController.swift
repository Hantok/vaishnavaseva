  import UIKit

struct Section
  {
  var date: String
  var firstIndex: Int
  var count: Int
  }

let allSadhanaEntriesStateViewEvent = "allSadhanaEntriesStateViewEvent"
let findSadhanaUserStateViewEvent = "findSadhanaUserStateViewEvent"

class GeneralSadhanaViewController: JSONTableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
  let kCellIdentifier = "PersonalCell"
  var pageNum = 0
  var itemsPerPage = 20
  var needToUpdateRefreshToken = false
  
  var searchController: UISearchDisplayController!
  var userSearchSet = [SadhanaUser]()
  var searchString = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.refreshControl = UIRefreshControl()
    
    firstTimeDownload()
    
    self.refreshControl?.attributedTitle = NSAttributedString(string: NSLocalizedString("Refreshing...", comment: "Refresh control text"))
    self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

    self.tableView.addInfiniteScrollingWithActionHandler(){
      self.insertRowAtBottom()
    }
    
    let searchBar = UISearchBar()
    searchBar.delegate = self
    searchBar.sizeToFit()
    searchBar.viewForBaselineLayout().tintColor = UIColor.init(hexString: "81D4F7")
    searchBar.barTintColor = UIColor.init(hexString: "EFEFF4")
    
    //uncomment for ALWAYS showing searchBar
//    self.tableView.tableHeaderView = searchBar
//    self.tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height)
    
    searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
    searchController.searchResultsDataSource = self
    searchController.searchResultsDelegate = self
    searchController.searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
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
  @IBAction func showSearchBar(sender: AnyObject) {
    self.tableView.tableHeaderView = searchController.searchBar //remove if ALWAYS showing searchBar
    self.searchController.searchBar.becomeFirstResponder()
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
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if tableView != self.tableView {
      return 1
    }
    return sections.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      if tableView != self.tableView {
        if (userSearchSet.count == 0 && self.searchString != "") {
          sendActionForStateViewEvent(findSadhanaUserStateViewEvent)
        }
        return userSearchSet.count
      }
      return sections[section].count
    }
    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
      var row = 0
      
      if tableView != self.tableView {
        var sadhanaUser = SadhanaUser()
        row = indexPath.row
        print("row \(row)")
        sadhanaUser = userSearchSet[row] 
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = sadhanaUser.userName
        let avatar_url = sadhanaUser.avatarUrl!
        if avatar_url != Constants.default_avatar_url
        {
          cell.imageView?.load(avatar_url, placeholder: UIImage(named: "default_avatar.gif"), completionHandler: nil)
        }
        else
        {
          cell.imageView?.image = UIImage(named: "default_avatar.gif")
        }
        
        return cell
        
      } else {
        let sadhanaEntry:SadhanaEntry
        let greenColor = UIColor(red: 0, green: 125/256, blue: 0, alpha: 1)
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as! GeneralSadhanaTableViewCell
        
        row = sections[indexPath.section].firstIndex + indexPath.row
        sadhanaEntry = entries[row]
        
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
        
        cell.javaView.countLabel.text = "\(sadhanaEntry.jCount730! + sadhanaEntry.jCount1000! + sadhanaEntry.jCount1800! + sadhanaEntry.jCountAfter!)"
        
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
    }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if tableView != self.tableView {
      return nil
    }
    let cell = tableView.dequeueReusableCellWithIdentifier("Header") as! GeneralSadhanaTableViewHeader
    cell.date.text = sections[section].date
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
    if tableView != self.tableView {
      return 0
    }
    return 30
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    if tableView != self.tableView {
      performSegueWithIdentifier("GeneralToPersonal", sender: nil)
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      return
    }
    let me = NSUserDefaults.standardUserDefaults().objectForKey("me")
    let i = sections[indexPath.section].firstIndex + indexPath.row
    if me != nil && (me as! NSDictionary).objectForKey("userid")?.integerValue == self.entries[i].sadhanaUser?.userId {
      performSegueWithIdentifier("GeneralToMy", sender: nil)
    } else {
      performSegueWithIdentifier("GeneralToPersonal", sender: nil)
    }
  }
  
  override func prepareForSegue(storyboardSegue: UIStoryboardSegue, sender: AnyObject?)
  {
    super.prepareForSegue(storyboardSegue, sender: sender)
    if (storyboardSegue.identifier == "GeneralToPersonal")
    {
      if self.userSearchSet.count != 0 {
        let indexPath = self.searchController.searchResultsTableView.indexPathForSelectedRow
        (storyboardSegue.destinationViewController as! PersonalSadhanaViewController).sadhanaUser = self.userSearchSet[(indexPath?.row)!]
        return
      }
      let indexPath = self.tableView.indexPathForSelectedRow!
      let row = sections[indexPath.section].firstIndex + indexPath.row
      (storyboardSegue.destinationViewController as! PersonalSadhanaViewController).sadhanaUser = self.entries[row].sadhanaUser!
    }
  }
  
  func firstTimeDownload() {
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
  
  // UISearchBarDelegate
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    self.userSearchSet = [SadhanaUser]()
    let filteredEntries = self.entries.filter({ (data: SadhanaEntry) -> Bool in
      let match = data.sadhanaUser?.userName!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
      self.searchString = searchText
      return match != nil
    })
    if filteredEntries.count == 0 {
      self.userSearchSet = [SadhanaUser]()
      return
    }
    for entry in filteredEntries {
      self.userSearchSet.append(entry.sadhanaUser!)
    }
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    self.tableView.tableHeaderView = nil
  }
}

