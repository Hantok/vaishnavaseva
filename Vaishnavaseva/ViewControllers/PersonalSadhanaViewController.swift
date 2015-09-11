import UIKit

let userSadhanaEntriesStateViewEvent = "userSadhanaEntriesStateViewEvent"

class PersonalSadhanaViewController: JSONTableViewController {
  
  var person : JSON = JSON.null
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = ((person)["user"])["user_name"].stringValue
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
    let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! PersonalSadhanaTableViewCell
    let row = sections[indexPath.section].firstIndex + indexPath.row
//      cell.name?.text = ((self.json[row])["user"])["user_name"].description
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
    
    cell.javaView.rounds0 = Int((self.json[row])["jcount_730"].description)!
    cell.javaView.rounds1 = Int((self.json[row])["jcount_1000"].description)!
    cell.javaView.rounds2 = Int((self.json[row])["jcount_1800"].description)!
    cell.javaView.rounds3 = Int((self.json[row])["jcount_after"].description)!
    
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

}

