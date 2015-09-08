  import UIKit

struct Section
  {
  var date: String
  var firstIndex: Int
  var count: Int
  }

let allSadhanaEntriesStateViewEvent = "allSadhanaEntriesStateViewEvent"

class GeneralSadhanaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  let refreshControl = UIRefreshControl()

  @IBOutlet var tableView: UITableView!
  
  var sections: [Section] = []
  var json: JSON = JSON.null
    {
    didSet
      {
      switch self.json.type
        {
        case Type.Array:
          var lastDate = ""
          if sections.count != 0
          {
            sections = []
          }
          for var i = 0; i < json.count; ++i
            {
              let currentDate = json[i]["date"].description
              if lastDate != currentDate
              {
                lastDate = currentDate
                sections.append(Section(date: lastDate, firstIndex: i, count: 0))
              }
              ++sections[sections.count - 1].count
            }
        default:
          break
        }
      }
    }
  var pageNum = 0
  var itemsPerPage = 20
  var totalFound = 120
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refresh(self)
    
    self.refreshControl.attributedTitle = NSAttributedString(string: "Refrishing...")
    self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(self.refreshControl)

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
        return sections.count
    }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[section].count
    }
    
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
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
        
        return cell
    }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
    let cell = tableView.dequeueReusableCellWithIdentifier("Header") as! GeneralSadhanaTableViewHeader
    cell.date.text = sections[section].date
    return cell
    }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
    return 30
    }
    
  func refresh(sender:AnyObject)
  {
    self.refreshControl.endRefreshing()
    self.pageNum = 0
    sendActionForStateViewEvent(allSadhanaEntriesStateViewEvent)
    let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
    spiningActivity.labelText = "Please wait"
//    spiningActivity.detailsLabelText = ""
  }
  
  func insertRowAtBottom() {
    let delayInSeconds = 2.0
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
      if (self.pageNum * self.itemsPerPage < self.totalFound)
      {
        ++self.pageNum
      }
      self.sendActionForStateViewEvent(allSadhanaEntriesStateViewEvent)
      self.tableView.infiniteScrollingView.stopAnimating()
    }
  }
  
  func showErrorAlert() {
    let alert = UIAlertController(title: "Server error", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

