import UIKit

class ActivityIndicatorsContainer
  {
  static var instanceCount = 0
  var activityIndicator: UIActivityIndicatorView?
    {
    didSet
      {
      if let activityIndicator = self.activityIndicator
        {
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        }
      }
    }
  
  init()
    {
    ++ActivityIndicatorsContainer.instanceCount
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
  
  deinit
    {
    --ActivityIndicatorsContainer.instanceCount
    if ActivityIndicatorsContainer.instanceCount <= 0//there are no other instances created already
      {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      if let activityIndicator = self.activityIndicator
        {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        self.activityIndicator = nil
        }
      }
    }
  }