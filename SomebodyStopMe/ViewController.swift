
//
//  ViewController.swift
//  SomebodyStopMe
//
//  Created by Lucas Rim on 10/30/15.
//  Copyright © 2015 Lucas Rim. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

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
        
        let urlPath : String = "http://localhost:3000/busstops/api"
        
        let parameters:[String:AnyObject] = [
            "address" : destination,
            "busLine" : busLine
        ]
        
        Alamofire.request(.POST, urlPath, parameters: parameters, encoding:.JSON).responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                }
        }


        
        }
        

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




