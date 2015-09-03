import UIKit

struct Section
  {
  var date: String
  var firstIndex: Int
  var count: Int
  }

class GeneralSadhanaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    "allSadhanaEntries".post(["items_per_page":"999999999"]) { response in
        print(response.responseJSON)
        var json = JSON(response.responseJSON!)
        let entry: AnyObject = (json.object as! NSDictionary).allKeys[0]
        json = json[entry as! String]
        self.json = json
        self.tableView.reloadData()
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
}

