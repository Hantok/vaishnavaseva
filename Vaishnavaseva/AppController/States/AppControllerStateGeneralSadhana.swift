import UIKit

@objc class AppControllerStateGeneralSadhana: AppControllerState
  {
//  override func isEqualTo(other: EquatableBase) -> Bool
//    {
//    let otherDynamic = other as! AppControllerStateFirst
//    return  super.isEqualTo(other) &&
//            self.state == otherDynamic.state
//    }
    
    
    var json: JSON = JSON.null
    let SADHANA_URL = NSURL(string: "http://vaishnavaseva.net/vs-api/v1/sadhana/allSadhanaEntries")
    
    override func sceneDidBecomeCurrent()
    {
        super.sceneDidBecomeCurrent()
//        self.viewController.setAction(Selector("onDone"), forTarget: self, forStateViewEvent: OnDoneStateViewEvent)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var running = false
        let request = NSMutableURLRequest(URL: SADHANA_URL!)
        request.HTTPMethod = "POST"
        //TODO: this is a hack, we need to ask for smaller portions several times instead!!!
        let postString = "items_per_page=999999999"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            if let _ = response as? NSHTTPURLResponse {
                //                dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                //                print(dataString)
                var json = JSON(data:data!)
                let entry: AnyObject = (json.object as! NSDictionary).allKeys[0]
                json = json[entry as! String]
                (self.viewController as! GeneralSadhanaViewController).json = json
            } else {
                (self.viewController as! GeneralSadhanaViewController).json = JSON.null
            }
            running = false
        }
        
        running = true
        task.resume()
        
        while running {
            print("waiting...")
            sleep(1)
        }

    }
  }
