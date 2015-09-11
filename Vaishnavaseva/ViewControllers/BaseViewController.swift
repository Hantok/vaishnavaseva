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

protocol BaseViewControllerProtocol
  {
  func setAction(action: Selector, forTarget target: AnyObject, forStateViewEvent stateEvent:StateViewEvent)
  func removeActionForStateViewEvent(stateEvent: StateViewEvent)
  func hasActionForStateViewEvent(stateEvent: StateViewEvent) ->Bool
  func sendActionForStateViewEvent(stateEvent: StateViewEvent) -> Bool
  }

class BaseViewControllerDelegate: BaseViewControllerProtocol
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
  
  func prepareForSegue(storyboardSegue: UIStoryboardSegue, sender: AnyObject?)
    {
    assert(storyboardSegue.destinationViewController is BaseViewControllerProtocol, "BaseViewControllerProtocol expected");
    let segueClass = NSClassFromString(storyboardSegue.identifier!) as! NSObject.Type
    let segue = segueClass.init() as! AppControllerSegue
    
    segue.sourceSceneController = AppController.sharedAppController.currentState;
    segue.visualSegue = storyboardSegue;
    
    segue.perform()
    }
  
  func didMoveToParentViewController(parent: UIViewController?)
    {
    if parent == nil//We are either going back or removing the view controller from list
      {
      sendActionForStateViewEvent(OnBackStateViewEvent)
      }
    }
  }

class BaseViewController: UIViewController, BaseViewControllerProtocol, UINavigationControllerDelegate, StateSerializable
  {
  private let baseViewControllerDelegate = BaseViewControllerDelegate()
  
  func setAction(action: Selector, forTarget target: AnyObject, forStateViewEvent stateEvent:StateViewEvent)
    {
    baseViewControllerDelegate.setAction(action, forTarget: target, forStateViewEvent: stateEvent)
    }
  
  func removeActionForStateViewEvent(stateEvent: StateViewEvent)
    {
    baseViewControllerDelegate.removeActionForStateViewEvent(stateEvent)
    }
  
  func hasActionForStateViewEvent(stateEvent: StateViewEvent) ->Bool
    {
    return baseViewControllerDelegate.hasActionForStateViewEvent(stateEvent)
    }
  
  func sendActionForStateViewEvent(stateEvent: StateViewEvent) -> Bool
    {
    return baseViewControllerDelegate.sendActionForStateViewEvent(stateEvent)
    }
  
  override func prepareForSegue(storyboardSegue: UIStoryboardSegue, sender: AnyObject?)
    {
    self.baseViewControllerDelegate.prepareForSegue(storyboardSegue, sender: sender)
    }
  
  override func didMoveToParentViewController(parent: UIViewController?)
    {
    self.baseViewControllerDelegate.didMoveToParentViewController(parent)
    }
  }

class BaseTableViewController: UITableViewController, BaseViewControllerProtocol, UINavigationControllerDelegate, StateSerializable
  {
  private let baseViewControllerDelegate = BaseViewControllerDelegate()
  
  func setAction(action: Selector, forTarget target: AnyObject, forStateViewEvent stateEvent:StateViewEvent)
    {
    baseViewControllerDelegate.setAction(action, forTarget: target, forStateViewEvent: stateEvent)
    }
  
  func removeActionForStateViewEvent(stateEvent: StateViewEvent)
    {
    baseViewControllerDelegate.removeActionForStateViewEvent(stateEvent)
    }
  
  func hasActionForStateViewEvent(stateEvent: StateViewEvent) ->Bool
    {
    return baseViewControllerDelegate.hasActionForStateViewEvent(stateEvent)
    }
  
  func sendActionForStateViewEvent(stateEvent: StateViewEvent) -> Bool
    {
    return baseViewControllerDelegate.sendActionForStateViewEvent(stateEvent)
    }
  
  override func prepareForSegue(storyboardSegue: UIStoryboardSegue, sender: AnyObject?)
    {
    self.baseViewControllerDelegate.prepareForSegue(storyboardSegue, sender: sender)
    }
  
  override func didMoveToParentViewController(parent: UIViewController?)
    {
    self.baseViewControllerDelegate.didMoveToParentViewController(parent)
    }
  }
