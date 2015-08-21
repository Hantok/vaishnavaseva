import UIKit

let OnDoneStateViewEvent = "OnDoneStateViewEvent"

class EditSadhanaViewController: BaseViewController {

  @IBOutlet weak var japaBooksPicker: UIPickerView!
  @IBOutlet weak var serviceSwitch: UISwitch!
  @IBOutlet weak var kirtanSwitch: UISwitch!
  @IBOutlet weak var lecturesSwitch: UISwitch!
  @IBOutlet weak var wakeupTimePicker: UIDatePicker!
  @IBOutlet weak var bedtimePicker: UIDatePicker!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  var activityIndicatorsContainer: ActivityIndicatorsContainer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func onDone(sender: AnyObject)
    {
    sendActionForStateViewEvent(OnDoneStateViewEvent);
    }
  
//  @IBAction func startIndicatingProgress(sender: AnyObject)
//    {
//    activityIndicatorsContainer = ActivityIndicatorsContainer()
//    activityIndicatorsContainer?.activityIndicator = activityIndicator
//    activityIndicatorsContainer?.start()
//    }
//  
//  @IBAction func stopIndicatingProgress(sender: AnyObject)
//    {
//    activityIndicatorsContainer?.stop()
//    //activityIndicatorsContainer = nil//this code stops the indicators too even if you don't call stop()
//    }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

