import Foundation

//@objc(ClassName) is needed to avoid having a module name in the class name for reflection, see BaseViewController.prepareForSegue()
@objc(MyToEdit) class MyToEdit : AppControllerSegue {
  
  override func perform() {
    let destinationState = AppControllerStateEditSadhana()
    destinationState.viewController = self.visualSegue.destinationViewController
    self.destinationSceneController = destinationState
    
    super.perform()
    //Transfer any data between AppControllerStates and ViewControllers here
    (self.destinationSceneController.viewController as! EditSadhanaViewController).sadhanaEntry = (self.sourceSceneController.viewController as! MySadhanaViewController).selectedSadhanaEntry!
  }
}
