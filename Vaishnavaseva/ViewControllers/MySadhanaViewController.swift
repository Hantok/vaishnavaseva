import UIKit

class MySadhanaViewController: BaseViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

