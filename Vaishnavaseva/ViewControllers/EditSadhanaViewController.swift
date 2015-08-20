import UIKit

let OnDoneStateViewEvent = "OnDoneStateViewEvent"

class EditSadhanaViewController: BaseViewController {

  var activityIndicatorsContainer: ActivityIndicatorsContainer?
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func onDone(sender: AnyObject)
    {
    sendActionForStateViewEvent(OnDoneStateViewEvent);
    }
  
  @IBAction func startIndicatingProgress(sender: AnyObject)
    {
    activityIndicatorsContainer = ActivityIndicatorsContainer()
    activityIndicatorsContainer?.activityIndicator = activityIndicator
    activityIndicatorsContainer?.start()
    }
  
  @IBAction func stopIndicatingProgress(sender: AnyObject)
    {
    activityIndicatorsContainer?.stop()
    //activityIndicatorsContainer = nil//this code stops the indicators too even if you don't call stop()
    }
  
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

