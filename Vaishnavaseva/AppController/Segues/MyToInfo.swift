import Foundation

//@objc(ClassName) is needed to avoid having a module name in the class name for reflection, see BaseViewController.prepareForSegue()
@objc(MyToInfo) class MyToInfo : AppControllerSegue
  {
  override func perform()
    {
    let destinationState = AppControllerStateInfo()
    destinationState.viewController = self.visualSegue.destinationViewController
    self.destinationSceneController = destinationState
    
    super.perform()
    //Transfer any data between AppControllerStates and ViewControllers here
    }
  }
