import UIKit

class LogInViewController: BaseViewController {

  @IBOutlet weak var japaView: JapaView!
  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  

  @IBAction func onButtonPressed(sender: AnyObject)
    {
    japaView.rounds0 = 16
    japaView.rounds1 = 16
    japaView.rounds2 = 16
    japaView.rounds3 = 16
    japaView.recalculateLayout()
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginTextField.text = "roman"
    passwordTextField.text = "Ubuntu108"
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidDisappear(animated: Bool)
    {
    //This is a hack to remove the LogInViewController from the stack so when we go back there is no SignIn screen any more, see also removal of the AppControllerStateLogIn from the stack in LogInToMy.perform()
    if AppController.sharedAppController.isLoggedIn
      {
      let myIndex = navigationController!.viewControllers.count - 2
      assert(self == navigationController!.viewControllers[myIndex])
      navigationController!.viewControllers.removeAtIndex(myIndex)
      }
    }
  
  override func didMoveToParentViewController(parent: UIViewController?)
    {
    //This is a hack: when we remove the LogInViewController from the stack (see viewDidDisappear() above, this method is called which then removes the last element from  AppController.previousStates like if a back button is pressed => crash, let's prevent this:
    if !AppController.sharedAppController.isLoggedIn
      {
      super.didMoveToParentViewController(parent)
      }
    }

  @IBAction func onLogIn(sender: AnyObject)
    {
    if login(loginTextField.text!, password: passwordTextField.text!)
    {
        AppController.sharedAppController.isLoggedIn = true
        performSegueWithIdentifier("LogInToMy", sender: nil)
    } else
    {
        let alert = UIAlertController(title: "Authorization error!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        passwordTextField.text = ""
        passwordTextField.becomeFirstResponder()
    }
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
    func login(login: String, password: String) -> Bool
    {
        var loginSuccess = false
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let userPasswordString = login + ":" + password
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let authString = "Basic \(base64EncodedCredential)"
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        let session = NSURLSession(configuration: config)
        
        var running = false
        let url = NSURL(string: "http://vaishnavaseva.net/vs-api/v1/sadhana/me")
        var dataString: NSString = ""
        let task = session.dataTaskWithURL(url!) {
            (let data, let response, let error) in
            if let _ = response as? NSHTTPURLResponse {
                dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                if ((response as? NSHTTPURLResponse)!.statusCode == 200)
                {
                    loginSuccess = true
                }
                print(dataString)
            }
            running = false
        }
        
        running = true
        task.resume()
        
        while running {
            print("waiting...")
            sleep(1)
        }
        return loginSuccess
    }

}

