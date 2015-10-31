
//
//  ViewController.swift
//  SomebodyStopMe
//
//  Created by Lucas Rim on 10/30/15.
//  Copyright © 2015 Lucas Rim. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var currentLocationLabel: UILabel!

    let locationManager = CLLocationManager()

    @IBOutlet weak var destinationField: UITextField!
    
    @IBOutlet weak var busLineField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

    }

    @IBAction func findMeButton(sender: AnyObject) {
        let myLat = String(locationManager.location!.coordinate.latitude)
        let myLong = String(locationManager.location!.coordinate.longitude)
        let myCoordinates = "\(myLat), \(myLong)"
        
        currentLocationLabel.text = myCoordinates
        
    }
    
    
    @IBAction func trackRouteButton(sender: AnyObject) {
        setCoordinates() { data, response, error in
            if error != nil {
                if error.domain == NSURLErrorDomain && error.code == NSURLErrorTimedOut {
                    print("timed out") // note, `response` is likely `nil` if it timed out
                }
            }
        }
    }
    
    func setCoordinates(callBack: ((data: NSArray!, response: NSURLResponse!, error: NSError!) -> Void)?) {
        var jsonData: NSArray = []
        
        let destination = destinationField.text!
        
        let busLine = busLineField.text!
//        
//        let myLat = String(locationManager.location!.coordinate.latitude)
//        let myLong = String(locationManager.location!.coordinate.longitude)
        
        let urlPath : String = "http://localhost:3000/busstops/api"
        
        let url : NSURL = NSURL(string: urlPath)!
        
        let request : NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        request.HTTPMethod = "POST"
        
//        let dataString = "{\"data\":{\"address\":\"\(destination)\",\"busLine\":\"\(busLine)\"}}"
        
        let data : NSString = "data='\(destination)','\(busLine)'"
        
        let requestBodyData = (data as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        let postLength = String(requestBodyData!.length)
        
        request.HTTPBody = requestBodyData
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {urlData, response, responseError in
            if let receivedData = urlData {
                let res = response as! NSHTTPURLResponse!;
                print("\(receivedData)")
                print("\(res)")
                NSLog("Response code: %ld", res.statusCode);
                
                if 200..<300 ~= res.statusCode {
                    do {
                        jsonData = try NSJSONSerialization.JSONObjectWithData(receivedData, options: []) as! NSArray
                        //On success, invoke `completion` with passing jsonData.
                        callBack?(data: jsonData, response: response, error: nil)
                    } catch let error as NSError {
                        let returnedError = NSError(domain: "findBusStopAsync", code: 3, userInfo: [
                            "title": "Could not find!",
                            "message": "Invalid Data!",
                            "cause": error
                            ])
                        //On error, invoke `completion` with NSError.
                        callBack?(data: nil, response: response, error: returnedError)
                    }
                } else {
                    let returnedError = NSError(domain: "findBusStopAsync", code: 1, userInfo: [
                        "title": "Could not find!",
                        "message": "Could not connect!"
                        ])
                    //On error, invoke `completion` with NSError.
                    callBack?(data: nil, response: response, error: returnedError)
                }
            } else {
                var userInfo: [NSObject: AnyObject] = [
                    "title": "Could not find!",
                    "message": "Could not connect"
                ]
                if let error = responseError {
                    userInfo["message"] = error.localizedDescription
                    userInfo["cause"] = error
                }
                let returnedError = NSError(domain: "findBusStopAsync", code: 2, userInfo: userInfo)
                //On error, invoke `completion` with NSError.
                callBack?(data: nil, response: response, error: returnedError)
            }

        }
        
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




