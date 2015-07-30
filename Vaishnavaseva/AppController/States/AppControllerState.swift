import UIKit


@objc protocol AppControllerStateProtocol: SceneController
  {
  // should not be called explicitly (are called by application controller)
  optional func applicationDidReceiveMemoryWarning(application:UIApplication)
  optional func applicationWillResignActive(application: UIApplication)
  optional func applicationDidBecomeActive(application: UIApplication)
  optional func applicationDidEnterBackground(application: UIApplication)
  optional func applicationWillEnterForeground(application: UIApplication)
  optional func applicationWillTerminate(application: UIApplication)
  }

@objc class AppControllerState: NSObject, EquatablePolymorphic, AppControllerStateProtocol, UINavigationControllerDelegate
  {
  var viewController: BaseViewController!
  
  func sceneDidBecomeCurrent()
    {
    self.viewController.setAction(Selector("pop"), forTarget: self, forStateViewEvent: OnBackStateViewEvent)
    }
  
  func isEqualTo(other: AppControllerState) -> Bool
    {
    if self.dynamicType != other.dynamicType
      {
      return false;
      }
    return  self.viewController == other.viewController
    }
  
  func pop()
    {
    let appController = AppController.sharedAppController
    let backState = appController.previousStates.last
    appController.previousStates.removeLast()
    appController.currentState = backState
    }
  
  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool)
    {
    (self.viewController as UINavigationControllerDelegate).navigationController?(navigationController, willShowViewController: viewController, animated: animated)
    }
  
  func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool)
    {
    assert(viewController == self.viewController)
    (self.viewController as UINavigationControllerDelegate).navigationController?(navigationController, didShowViewController: viewController, animated: animated)
    }
  
  }
