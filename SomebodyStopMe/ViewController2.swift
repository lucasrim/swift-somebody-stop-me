//
//  ViewController2.swift
//  SomebodyStopMe
//
//  Created by Lucas Rim on 11/2/15.
//  Copyright © 2015 Lucas Rim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController2: UIViewController, CLLocationManagerDelegate {
    var manager: CLLocationManager?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    @IBOutlet weak var onnscreenMap: MKMapView!
    @IBOutlet weak var address: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.delegate = self;
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestAlwaysAuthorization()
        manager?.startUpdatingLocation()
        let currentRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 1000, identifier: "Test")
        manager?.startMonitoringForRegion(currentRegion)
    }
    
    
    @IBAction func getLocation(sender: AnyObject) {
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        print("test1")
    }
    
    @IBAction func regionMonitoring(sender: AnyObject) {
        manager?.requestAlwaysAuthorization()
        print("test2")
        let currentRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 1000, identifier: "Test")
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
        entryNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
        entryNotification.alertBody = "Your bus stop is approaching. Be prepared to get off the bus shortly."
        entryNotification.soundName = "SomebodyStopMeBell.aiff"
        entryNotification.timeZone = NSTimeZone.defaultTimeZone()
        entryNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(entryNotification)
        print("test4")
        
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!){
        NSLog("Have you missed your stop?")
        var exitNotification = UILocalNotification()
        exitNotification.alertBody = "Oh no, have you missed your stop?"
        exitNotification.soundName = "SomebodyStopMeBell.aiff"
        exitNotification.timeZone = NSTimeZone.defaultTimeZone()
        exitNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(exitNotification)
        print("test5")
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        NSLog("Something has gone terribly wrong.")
    }
}
