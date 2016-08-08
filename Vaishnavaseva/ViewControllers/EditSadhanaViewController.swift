import UIKit

let pickerHeightMinimized: CGFloat = 36
let pickerHeightMaximized: CGFloat = 216//may be took from the picker view itself

struct SadhanaTypesEnableState {
  var Wake = true
  var Sleep = true
  var Service = true
  var Joga = true
  var Lectures = true
}

let OnDoneStateViewEvent = "OnDoneStateViewEvent"

class EditSadhanaViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate, HitTestDelegate {
  
  @IBOutlet weak var booksMinutesTextField: UITextField!
  @IBOutlet weak var booksMinutesStepperControl: UIStepper!
  @IBOutlet weak var kirtanSwitch: UISwitch!
  @IBOutlet weak var serviceSwitch: UISwitch!
  @IBOutlet weak var jogaSwitch: UISwitch!
  @IBOutlet weak var lecturesSwitch: UISwitch!
  @IBOutlet weak var japaRoundsPickerView: HitTestPicker!
  @IBOutlet weak var japaRoundsPickerSuperviewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var japaRoundsPickerSuperviewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var wakeTimePickerView: HitTestDatePicker!
  @IBOutlet weak var wakeTimePickerSuperviewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var wakeTimePickerSuperviewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var sleepTimePickerView: HitTestDatePicker!
  @IBOutlet weak var sleepTimePickerSuperviewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var sleepTimePickerSuperviewTopConstraint: NSLayoutConstraint!
  var superviewHeightConstraints: [NSLayoutConstraint] = []
  var superviewTopConstraints: [NSLayoutConstraint] = []
  
  var sadhanaTypesEnableState = SadhanaTypesEnableState()
  
  var animationsEnabled = false
  var lastAnimatedView: UIView?
  var minimizationTimer: NSTimer?
  
  var sadhanaEntry = SadhanaEntry()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = sadhanaEntry.date
    
    japaRoundsPickerView.hitTestDelegate = self
    wakeTimePickerView.hitTestDelegate = self
    sleepTimePickerView.hitTestDelegate = self
    
    japaRoundsPickerView.tag = 0
    wakeTimePickerView.tag = 1
    sleepTimePickerView.tag = 2
    
    superviewHeightConstraints = [
      japaRoundsPickerSuperviewHeightConstraint,
      wakeTimePickerSuperviewHeightConstraint,
      sleepTimePickerSuperviewHeightConstraint]
    superviewTopConstraints = [
      japaRoundsPickerSuperviewTopConstraint,
      wakeTimePickerSuperviewTopConstraint,
      sleepTimePickerSuperviewTopConstraint]
    
    //Apply active sadhana types from user settings here like next:
//    sadhanaTypesEnableState.Sleep = false
//    sadhanaTypesEnableState.Joga = false
    
    wakeTimePickerView.userInteractionEnabled = sadhanaTypesEnableState.Wake
    sleepTimePickerView.userInteractionEnabled = sadhanaTypesEnableState.Sleep
    serviceSwitch.enabled = sadhanaTypesEnableState.Service
    jogaSwitch.enabled = sadhanaTypesEnableState.Joga
    lecturesSwitch.enabled = sadhanaTypesEnableState.Lectures
    if let reading = self.sadhanaEntry.reading {
        booksMinutesTextField.text = reading > 0 ? String("\(reading)") : ""
        booksMinutesStepperControl.value = Double(reading)
    }
    if let kirtan = self.sadhanaEntry.kirtan {
        kirtanSwitch.setOn(kirtan, animated: false)
    }
    if let jCount730 = self.sadhanaEntry.jCount730 {
        japaRoundsPickerView.selectRow(jCount730, inComponent: 0, animated: false)
    }
    if let jCount1000 = self.sadhanaEntry.jCount1000 {
        japaRoundsPickerView.selectRow(jCount1000, inComponent: 1, animated: false)
    }
    if let jCount1800 = self.sadhanaEntry.jCount1800 {
        japaRoundsPickerView.selectRow(jCount1800, inComponent: 2, animated: false)
    }
    if let jCountAfter = self.sadhanaEntry.jCountAfter {
        japaRoundsPickerView.selectRow(jCountAfter, inComponent: 3, animated: false)
    }
    
    let dateFormat: NSDateFormatter = NSDateFormatter()
    dateFormat.dateFormat = "HH:mm"
    if let wakeUpTime = self.sadhanaEntry.wakeUpTime {
        wakeTimePickerView.date = dateFormat.dateFromString(wakeUpTime)!
    }
    if let sleepTime = self.sadhanaEntry.sleepTime {
        sleepTimePickerView.date = dateFormat.dateFromString(sleepTime)!
    }
    if let serviceEnable = self.sadhanaEntry.serviceEnable {
        serviceSwitch.setOn(serviceEnable, animated: false)
    }
    if let exerciseEnable = self.sadhanaEntry.exerciseEnable {
        jogaSwitch.setOn(exerciseEnable, animated: false)
    }
    if let lectionsEnable = self.sadhanaEntry.lectionsEnable {
        lecturesSwitch.setOn(lectionsEnable, animated: false)
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    animationsEnabled = true
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    booksMinutesTextField.endEditing(true)
  }
  
  @IBAction func onDone(sender: AnyObject) {
    self.sadhanaEntry.reading = booksMinutesTextField.text! == "" ? 0 : Int(booksMinutesTextField.text!)
    self.sadhanaEntry.kirtan = kirtanSwitch.on
    
    let dateFormat: NSDateFormatter = NSDateFormatter()
    dateFormat.dateFormat = "HH:mm"
    self.sadhanaEntry.wakeUpTime = dateFormat.stringFromDate(wakeTimePickerView.date)
    self.sadhanaEntry.sleepTime = dateFormat.stringFromDate(sleepTimePickerView.date)
    
    self.sadhanaEntry.serviceEnable = serviceSwitch.on
    self.sadhanaEntry.exerciseEnable = jogaSwitch.on
    self.sadhanaEntry.lectionsEnable = lecturesSwitch.on
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
    spiningActivity.labelText = NSLocalizedString("Please wait", comment: "Activity indicator text")
    sendActionForStateViewEvent(OnDoneStateViewEvent)
  }
  
  @IBAction func onStepperValueChanged(stepper: UIStepper) {
    booksMinutesTextField.text = String("\(Int(stepper.value))")
  }
  
  //func textViewDidChange(_ textView: UITextView)
  @IBAction func onCountTextFieldEditingChanged(textField: UITextField) {
    if let value = Double((textField.text)!) {
      booksMinutesStepperControl.value = value
    } else {
      booksMinutesStepperControl.value = 0
    }
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 4
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 65
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(row)
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch component {
    case 0:
      self.sadhanaEntry.jCount730 = row
    case 1:
      self.sadhanaEntry.jCount1000 = row
    case 2:
      self.sadhanaEntry.jCount1800 = row
    default:
      self.sadhanaEntry.jCountAfter = row //3
    }
    self.minimizeViewAnimatedIfNeeded()
  }
  
  @IBAction func onWakeTimeChanged(sender: UIDatePicker) {
    self.minimizeViewAnimatedIfNeeded()
  }
  
  @IBAction func onSleapDateChanged(sender: UIDatePicker) {
    self.minimizeViewAnimatedIfNeeded()
  }
  
  func minimizeViewAnimatedIfNeeded() {
    if let lastAnimated = lastAnimatedView {
      minimizeViewAnimated(lastAnimated)
      lastAnimatedView = nil
    }
  }
  
  func hitTestCalledForView(view: UIView){
    self.view.endEditing(true)
    if animationsEnabled  && lastAnimatedView != view {
      if let lastAnimated = lastAnimatedView {
        minimizeViewAnimated(lastAnimated)
      }
      lastAnimatedView = view
      maximizeViewAnimated(view)
      minimizationTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(EditSadhanaViewController.minimizeViewAnimatedIfNeeded), userInfo: nil, repeats: false)
    }
  }
  
  func maximizeView(view: UIView) {
    self.view.bringSubviewToFront(view.superview!)
    superviewTopConstraints[view.tag].constant -= (pickerHeightMaximized - pickerHeightMinimized)/2.0
    superviewHeightConstraints[view.tag].constant = pickerHeightMaximized
    self.view.layoutIfNeeded()
    self.view.bringSubviewToFront(view.superview!)
  }
  
  func maximizeViewAnimated(view: UIView){
    UIView.animateWithDuration(0.5, delay: 0, options: [.AllowUserInteraction], animations: {self.maximizeView(view)}, completion: nil)
    //    UIView.animateWithDuration(0.3) {//[.AllowUserInteraction] is needed here!!!
    //      self.maximizeView(view)
    //    }
  }
  
  func minimizeView(view: UIView) {
    superviewTopConstraints[view.tag].constant += (pickerHeightMaximized - pickerHeightMinimized)/2.0
    superviewHeightConstraints[view.tag].constant = pickerHeightMinimized
    self.view.layoutIfNeeded()
  }
  
  func minimizeViewAnimated(view: UIView){
    UIView.animateWithDuration(0.3) {
      self.minimizeView(view)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  deinit {
    minimizationTimer?.invalidate()
  }
  
}

