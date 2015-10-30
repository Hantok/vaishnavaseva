import UIKit

protocol HitTestDelegate: class {
  func hitTestCalledForView(view: UIView)
}

class HitTestPicker: UIPickerView {

  var hitTestDelegate: HitTestDelegate!
  
  override func becomeFirstResponder() -> Bool {
    return super.becomeFirstResponder()
  }
  
  override func canBecomeFirstResponder() -> Bool {
    return super.canBecomeFirstResponder()
  }
  
  override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
    hitTestDelegate.hitTestCalledForView(self)
    //print("hitTest")
    return super.hitTest(point, withEvent: event)
  }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
