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
    if parent == nil
      {
      sendActionForStateViewEvent(OnBackStateViewEvent)
      }
    }
  
  }
