import UIKit

class InfoViewController: BaseViewController, UIWebViewDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Render the web view under the status bar */
    var frame = self.view.bounds
    frame.origin.y = (self.navigationController?.navigationBar.bounds.height)! + UIApplication.sharedApplication().statusBarFrame.height
    frame.size.height -= frame.origin.y
    
    let webView = UIWebView(frame: frame)
    webView.delegate = self
    webView.scalesPageToFit = true
    view.addSubview(webView)

    let localfilePath = NSBundle.mainBundle().URLForResource("info", withExtension: "html")
    let localRequest = NSURLRequest(URL: localfilePath!)
    webView.loadRequest(localRequest)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    if navigationType == UIWebViewNavigationType.LinkClicked {
      //open link in Safari
      UIApplication.sharedApplication().openURL(request.URL!)
      return false;
    }
    return true
  }
}

