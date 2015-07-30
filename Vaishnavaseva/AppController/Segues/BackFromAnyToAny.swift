import Foundation

//@objc(ClassName) is needed to avoid having a module name in the class name for reflection, see BaseViewController.prepareForSegue()
@objc(BackFromAnyToAny) class BackFromAnyToAny : AppControllerSegue
  {
  override func perform()
    {
    super.perform()//sets the destinationSceneController
    self.destinationSceneController.viewController = self.visualSegue.destinationViewController as! BaseViewController
    
    //Transfer any data between AppControllerStates and ViewControllers here
    }
  }
