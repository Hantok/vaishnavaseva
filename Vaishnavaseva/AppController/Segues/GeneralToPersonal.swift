import Foundation

//@objc(ClassName) is needed to avoid having a module name in the class name for reflection, see BaseViewController.prepareForSegue()
@objc(GeneralToPersonal) class GeneralToPersonal : AppControllerSegue
  {
  override func perform()
    {
    let destinationState = AppControllerStatePersonalSadhana()
    destinationState.viewController = self.visualSegue.destinationViewController
    self.destinationSceneController = destinationState
    
    super.perform()
    //Transfer any data between AppControllerStates and ViewControllers here
    }
  }
