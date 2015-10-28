import UIKit

enum sadhanaType: Int {
  case Books, Kirtan, Japa, Wake, Sleep, Service, Joga, Lectures, Count
}

let OnDoneStateViewEvent = "OnDoneStateViewEvent"

class EditSadhanaViewController: BaseTableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  //  @IBOutlet weak var japaBooksPicker: UIPickerView!
  //  @IBOutlet weak var serviceSwitch: UISwitch!
  //  @IBOutlet weak var kirtanSwitch: UISwitch!
  //  @IBOutlet weak var lecturesSwitch: UISwitch!
  //  @IBOutlet weak var wakeupTimePicker: UIDatePicker!
  //  @IBOutlet weak var bedtimePicker: UIDatePicker!
  
  var booksReadInMinutes = 0
  var kirtanDone = false
  var serviceDone = false
  var jogaDone = false
  var lecturesDone = false
  
  var sadhanaTypesActive: [Bool] = Array(count: sadhanaType.Count.rawValue, repeatedValue: true)
  var activeRows: [Int]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //Apply active sadhana types from user settings here:
    //sadhanaTypesActive[sadhanaTypesOrder.indexOf("sleep")!] = false
    
    activeRows = []
    for (row, active) in sadhanaTypesActive.enumerate() {
      if active {
        activeRows.append(row)
      }
    }
  }
  
  @IBAction func onDone(sender: AnyObject) {
    sendActionForStateViewEvent(OnDoneStateViewEvent)
  }
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return activeRows.count
  }
  
  //override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
  //}
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let row = activeRows[indexPath.row]
    switch row {
    case sadhanaType.Books.rawValue:
      let cell = tableView.dequeueReusableCellWithIdentifier("EditCountSadhanaTableViewCell") as! EditCountSadhanaTableViewCell
      cell.label.text = NSLocalizedString("Books, min", comment: "Books label in edit sadhana")
      cell.countTextField.text = booksReadInMinutes > 0 ? String("\(booksReadInMinutes)") : ""
      cell.stepperControl.value = Double(booksReadInMinutes)
      return cell
    case sadhanaType.Kirtan.rawValue:
      let cell = tableView.dequeueReusableCellWithIdentifier("EditBoolSadhanaTableViewCell") as! EditBoolSadhanaTableViewCell
      cell.label.text = NSLocalizedString("Kirtan", comment: "Kirtan label in edit sadhana")
      cell.switchControl.setOn(kirtanDone, animated: false)
      return cell
    case sadhanaType.Japa.rawValue:
      let cell = tableView.dequeueReusableCellWithIdentifier("EditBoolSadhanaTableViewCell") as! EditBoolSadhanaTableViewCell
      cell.label.text = NSLocalizedString("Kirtan", comment: "Kirtan label in edit sadhana")
      cell.switchControl.setOn(kirtanDone, animated: false)
      return cell
    case sadhanaType.Wake.rawValue:
      let cell = tableView.dequeueReusableCellWithIdentifier("EditBoolSadhanaTableViewCell") as! EditBoolSadhanaTableViewCell
      cell.label.text = NSLocalizedString("Kirtan", comment: "Kirtan label in edit sadhana")
      cell.switchControl.setOn(kirtanDone, animated: false)
      return cell
    case sadhanaType.Sleep.rawValue:
      let cell = tableView.dequeueReusableCellWithIdentifier("EditBoolSadhanaTableViewCell") as! EditBoolSadhanaTableViewCell
      cell.label.text = NSLocalizedString("Kirtan", comment: "Kirtan label in edit sadhana")
      cell.switchControl.setOn(kirtanDone, animated: false)
      return cell
    case sadhanaType.Service.rawValue:
      let cell = tableView.dequeueReusableCellWithIdentifier("EditBoolSadhanaTableViewCell") as! EditBoolSadhanaTableViewCell
      cell.label.text = NSLocalizedString("Service", comment: "Service label in edit sadhana")
      cell.switchControl.setOn(kirtanDone, animated: false)
      return cell
    case sadhanaType.Joga.rawValue:
      let cell = tableView.dequeueReusableCellWithIdentifier("EditBoolSadhanaTableViewCell") as! EditBoolSadhanaTableViewCell
      cell.label.text = NSLocalizedString("Joga", comment: "Joga label in edit sadhana")
      cell.switchControl.setOn(kirtanDone, animated: false)
      return cell
    default://lectures
      let cell = tableView.dequeueReusableCellWithIdentifier("EditBoolSadhanaTableViewCell") as! EditBoolSadhanaTableViewCell
      cell.label.text = NSLocalizedString("Lectures", comment: "Lectures label in edit sadhana")
      cell.switchControl.setOn(kirtanDone, animated: false)
      return cell
    }
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 5
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if component == 4 {
      return 24*4//15 minutes interval is 1/4 of an hour
    } else {
      return 65
    }
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if component == 4 {
      return String(row*15)
    } else {
      return String(row)
    }
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

