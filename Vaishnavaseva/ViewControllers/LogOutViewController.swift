import UIKit

class LogOutViewController: BaseViewController {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var photo: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    let me = NSUserDefaults.standardUserDefaults().objectForKey("me") as! NSDictionary
    let sadhanaUser = Deserialiser().getSadhanaUser(me)
    self.nameLabel.text = sadhanaUser.userName
    self.photo.load(sadhanaUser.avatarUrl!)
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func onLogOut(sender: AnyObject)
    {
      AppController.sharedAppController.isLoggedIn = false
      NSUserDefaults.standardUserDefaults().removeObjectForKey("me")
      performSegueWithIdentifier("BackFromAnyToAny", sender: nil)
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

