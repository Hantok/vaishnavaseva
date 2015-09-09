import UIKit


class StateActionRecord
  {
  let action: Selector
  let target: AnyObject
  init(action: Selector, target: AnyObject)
    {
    self.action = action
    self.target = target
    }
  }

typealias StateViewEvent = String;

let OnBackStateViewEvent = "OnBackStateViewEvent"

class BaseViewController: UIViewController, UINavigationControllerDelegate, StateSerializable
{
  private var stateViewActions: Dictionary<StateViewEvent, StateActionRecord> = [:]
  
  func setAction(action: Selector, forTarget target: AnyObject, forStateViewEvent stateEvent:StateViewEvent)
    {
    stateViewActions[stateEvent] = StateActionRecord(action: action, target: target)
    }
  
  func removeActionForStateViewEvent(stateEvent: StateViewEvent)
    {
    stateViewActions.removeValueForKey(stateEvent)
    }
  
  func hasActionForStateViewEvent(stateEvent: StateViewEvent) ->Bool
    {
    return nil != stateViewActions[stateEvent];
    }
  
  func sendActionForStateViewEvent(stateEvent: StateViewEvent) -> Bool
    {
    if let actionRecord = stateViewActions[stateEvent]
      {
      return UIApplication.sharedApplication().sendAction(actionRecord.action, to: actionRecord.target, from: self, forEvent: nil)
      }
    return false;
    }
  
  override func prepareForSegue(storyboardSegue: UIStoryboardSegue, sender: AnyObject?)
    {
    assert(storyboardSegue.destinationViewController is BaseViewController, "BaseViewController subclass expected");
    let segueClass = NSClassFromString(storyboardSegue.identifier!) as! NSObject.Type
    let segue = segueClass.init() as! AppControllerSegue
    
    segue.sourceSceneController = AppController.sharedAppController.currentState;
    segue.visualSegue = storyboardSegue;
    
    segue.perform()
    }
  
  override func didMoveToParentViewController(parent: UIViewController?)
    {
    if parent == nil//We are either going back or removing the view controller from list
      {
      sendActionForStateViewEvent(OnBackStateViewEvent)
      }
    }
  
  var sections: [Section] = []
  var json: JSON = JSON.null
    {
    didSet
    {
      switch self.json.type
      {
      case Type.Array:
        var lastDate = ""
        if sections.count != 0
        {
          sections = []
        }
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
  
  func showErrorAlert() {
    let alert = UIAlertController(title: "Server error", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}
