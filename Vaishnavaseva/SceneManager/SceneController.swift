import Foundation
import UIKit

@objc protocol SceneController: StateSerializable
  {
  var viewController: BaseViewController! {get set}
  
  optional func sceneWillResignCurrent()
  optional func sceneDidResignCurrent()
  optional func sceneWillBecomeCurrent()
  optional func sceneDidBecomeCurrent()
  }
