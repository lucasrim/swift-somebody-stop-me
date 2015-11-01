//
//  ViewController.swift
//  SomebodyStopMeNotifications
//
//  Created by Sheena on 10/31/15.
//  Copyright © 2015 Somebody Stop Me. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var manager: CLLocationManager?
    
    @IBOutlet weak var onnscreenMap: MKMapView!
    @IBOutlet weak var address: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.delegate = self;
        manager?.desiredAccuracy = kCLLocationAccuracyBest
       // manager?.requestAlwaysAuthorization()
       // manager?.startUpdatingLocation()
       
        print("test")
    }
    
    
    @IBAction func getLocation(sender: AnyObject) {
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        print("test1")
    }
    

    @IBAction func regionMonitoring(sender: AnyObject) {
        manager?.requestAlwaysAuthorization()
        print("test2")
        
        let currentRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 41.889717, longitude: -87.637611), radius: 200, identifier: "Test")
        manager?.startMonitoringForRegion(currentRegion)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        let location = locations[0] as CLLocation
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            
            let placeMarks = data ?? []
            
            let loc: CLPlacemark = placeMarks[0]
            
            self.onnscreenMap.centerCoordinate = location.coordinate
            
            let addr = loc.locality
            
            self.address.text = addr
            
            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
            
            self.onnscreenMap.setRegion(reg, animated: true)
            
            self.onnscreenMap.showsUserLocation = true
            
        })
        
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!){
        NSLog("Your bus stop is approaching.")
        var entryNotification = UILocalNotification()
        entryNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        entryNotification.alertBody = "Your bus stop is approaching. Be prepared to get off the bus shortly."
        entryNotification.timeZone = NSTimeZone.defaultTimeZone()
        entryNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(entryNotification)
        print("test4")

    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!){
        NSLog("This is a test to see if we are cooking with gas.")
        var exitNotification = UILocalNotification()
        exitNotification.alertBody = "Test, test, test."
        exitNotification.timeZone = NSTimeZone.defaultTimeZone()
        exitNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(exitNotification)
        print("test5")

    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        NSLog("Something has gone terribly wrong.")
    }
}
