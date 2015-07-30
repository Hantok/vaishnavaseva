import Foundation

//@objc(ClassName) is needed to avoid having a module name in the class name for reflection, see BaseViewController.prepareForSegue()
@objc(LogInToMy) class LogInToMy : AppControllerSegue
  {
  override func perform()
    {
    let destinationState = AppControllerStateMySadhana()
    destinationState.viewController = self.visualSegue.destinationViewController as! BaseViewController
    self.destinationSceneController = destinationState
    
    super.perform()
    //Transfer any data between AppControllerStates and ViewControllers here
    
    //This is a hack to remove the AppControllerStateLogIn from the stack so when we go back there is no SignIn screen any more, see also removal of LogInViewController in LogInViewController.viewDidDisappear()
    AppController.sharedAppController.previousStates.removeLast()
    }
  }
