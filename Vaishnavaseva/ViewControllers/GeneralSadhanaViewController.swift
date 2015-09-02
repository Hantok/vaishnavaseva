import UIKit

class GeneralSadhanaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var tableView: UITableView!
    
    var json: JSON = JSON.null
  
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
        switch self.json.type {
        case Type.Array, Type.Dictionary:
            return self.json.count
        default:
            return 1
        }
    }
    
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let greenColor = UIColor(colorLiteralRed: 0, green: 125/256, blue: 0, alpha: 1)
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonalCell", forIndexPath: indexPath) as! GeneralSadhanaTableViewCell
        let row = indexPath.row
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
    return cell
    }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
    return 30
    }
}

