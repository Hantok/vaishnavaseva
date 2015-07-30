import Foundation
import UIKit

protocol AppControllerSegueProtocol
  {
  var sourceSceneController: SceneController! {get set}
  var destinationSceneController: SceneController! {get set}
  func perform()
  }

//Subclasses are very specific classes, every one of them:
// - Knows everything about both AppControllerStates and ViewControllers it is transfering between
// - Lives for a very short time while transitioning
// - Is needed to transfer data in between AppControllerStates and ViewControllers
// - Helps to minimize connectivity between states and avoid having one superheavy and smart object than knows everything about every AppControllerState and ViewController

@objc class AppControllerSegue: NSObject, AppControllerSegueProtocol//NSObject and @objc is needed for reflection to work, see BaseViewController.prepareForSegue()
  {
  var sourceSceneController: SceneController!
  
  var destinationSceneController: SceneController!
  
  var visualSegue: UIStoryboardSegue!
  
  
//We don't care of memory footprint size yet: maximum 3 screens in stack for now,
//So we just save all the previous states as objects in AppController.previousStates
//As well as use standard navigation controller which keeps all the previous view controllers alive
//This means we don't need to save/load AppControllerState's state here
  func perform()
    {
    let isSegueBack = self.visualSegue.identifier!.hasPrefix("BackFrom")
    if (!isSegueBack)
      {
      //saveSourceViewControllerState();
      //saveSourceAppControllerState();
      AppController.sharedAppController.previousStates.append(sourceSceneController as! AppControllerState)
      }
    else
      {
      //loadDestinationAppControllerState();
      //loadDestinationViewControllerState();
      
      let appController = AppController.sharedAppController
      let backState = appController.previousStates.last
      
      //Next code is not needed here as didMoveToParentViewController method is called anyway by navigation controller
//      appController.previousStates.removeLast()

      destinationSceneController = backState
      }
    
    AppController.sharedAppController.currentState = self.destinationSceneController as! AppControllerState
    }
  
  //Helper methods:
  
//  func saveSourceAppControllerState()
//    {
//    if let persistentState = (sourceSceneController as StateSerializable).persistentState?()
//      {
//      NSUserDefaults.standardUserDefaults().setObject(persistentState, forKey: NSStringFromClass(sourceSceneController!.dynamicType) + "_State")
//      }
//    }
  
//  func loadDestinationAppControllerState()
//    {
//    if let persistentState = NSUserDefaults.standardUserDefaults().objectForKey(NSStringFromClass(destinationSceneController!.dynamicType) + "_State")
//      {
//      destinationSceneController.loadPersistentState?(persistentState)
//      }
//    }
//  
//  func saveSourceViewControllerState()
//    {
//    if let persistentState = (visualSegue.sourceViewController as? StateSerializable)?.persistentState?()
//      {
//      NSUserDefaults.standardUserDefaults().setObject(persistentState, forKey: NSStringFromClass(visualSegue.sourceViewController.dynamicType) + "_ViewControllerState")
//      }
//    }
//  
//  func loadDestinationViewControllerState()
//    {
//    let destinationViewController = visualSegue.destinationViewController as! StateSerializable
//    if let persistentState = NSUserDefaults.standardUserDefaults().objectForKey(NSStringFromClass(destinationViewController.dynamicType) + "_ViewControllerState")
//      {
//      destinationViewController.loadPersistentState?(persistentState)
//      }
//    }
  }
