import UIKit

class ActivityIndicatorsContainer
  {
  var activityIndicator: UIActivityIndicatorView?
  
  func start()
    {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    if let activityIndicator = self.activityIndicator
      {
      activityIndicator.startAnimating()
      activityIndicator.hidden = false
      }
    }
  
  func stop()
    {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    if let activityIndicator = self.activityIndicator
      {
      activityIndicator.stopAnimating()
      activityIndicator.hidden = true
      }
    }
  
  deinit
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