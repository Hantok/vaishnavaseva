import Foundation

//@objc(ClassName) is needed to avoid having a module name in the class name for reflection, see BaseViewController.prepareForSegue()
@objc(GeneralToMy) class GeneralToMy : AppControllerSegue
  {
  override func perform()
    {
    let destinationState = AppControllerStateMySadhana()
    destinationState.viewController = self.visualSegue.destinationViewController as! BaseViewController
    self.destinationSceneController = destinationState
    
    super.perform()
    //Transfer any data between AppControllerStates and ViewControllers here
    }
  }
