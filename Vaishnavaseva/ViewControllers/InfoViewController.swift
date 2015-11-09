import UIKit

class InfoViewController: BaseViewController, UIWebViewDelegate {
  @IBOutlet weak var webView: UIWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView.delegate = self
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

