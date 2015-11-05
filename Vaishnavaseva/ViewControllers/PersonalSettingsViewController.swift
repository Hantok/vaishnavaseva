import UIKit

let OnDoneSettingsStateViewEvent = "OnDoneSettingsStateViewEvent"

class PersonalSettingsViewController: BaseViewController {
  @IBOutlet weak var sleepEnableSwitch: UISwitch!
  @IBOutlet weak var wakeUpEnableSwitch: UISwitch!
  @IBOutlet weak var exerciseEnableSwitch: UISwitch!
  @IBOutlet weak var serviceEnableSwitch: UISwitch!
  @IBOutlet weak var lecturesEnableSwitch: UISwitch!
  @IBOutlet weak var publicEnableSwitch: UISwitch!
  @IBOutlet weak var showMore16Switch: UISwitch!
  
  var me = SadhanaUser()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    me = Deserialiser().getSadhanaUser(NSUserDefaults.standardUserDefaults().objectForKey("me") as! NSDictionary)
    sleepEnableSwitch.on = me.sleepEnable!
    wakeUpEnableSwitch.on = me.wakeUpEnable!
    exerciseEnableSwitch.on = me.exerciseEnable!
    serviceEnableSwitch.on = me.serviceEnable!
    lecturesEnableSwitch.on = me.lectionsEnable!
    publicEnableSwitch.on = me.publicEnable! == true ? false : true
    showMore16Switch.on = me.showMore16! == true ? false : true    
  }
  
  @IBAction func onDone(sender: AnyObject) {
    
    let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
    spiningActivity.labelText = NSLocalizedString("Please wait", comment: "Activity indicator text")
    
    me.sleepEnable = sleepEnableSwitch.on
    me.wakeUpEnable = wakeUpEnableSwitch.on
    me.exerciseEnable = exerciseEnableSwitch.on
    me.serviceEnable = serviceEnableSwitch.on
    me.lectionsEnable = lecturesEnableSwitch.on
    me.publicEnable = publicEnableSwitch.on == true ? false : true
    me.showMore16 = showMore16Switch.on == true ? false : true
    
    sendActionForStateViewEvent(OnDoneSettingsStateViewEvent)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

