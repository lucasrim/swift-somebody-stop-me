
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
        setCoordinates()
    }
    
    func setCoordinates() {
        
        let destination = destinationField.text!
        
        let busLine = busLineField.text!
//        
//        let myLat = String(locationManager.location!.coordinate.latitude)
//        let myLong = String(locationManager.location!.coordinate.longitude)
        
        let urlPath : String = "http://localhost:3000/busstops/api.json"
        
        let url : NSURL = NSURL(string: urlPath)!
        
        let request : NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        request.HTTPMethod = "POST"
        
//        let dataString = "{\"data\":{\"address\":\"\(destination)\",\"busLine\":\"\(busLine)\"}}"
        
        let data : NSString = "data=['\(destination)', '\(busLine)']"
        
        let requestBodyData = (data as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        let postLength = String(requestBodyData!.length)
        
        request.HTTPBody = requestBodyData
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {urlData, response, responseError in
            print("")
        }
        
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




