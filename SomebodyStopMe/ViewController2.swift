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

class ViewController2: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
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
        let currentRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 700, identifier: "Test")
        manager?.startMonitoringForRegion(currentRegion)
        let location = CLLocation(latitude: latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees)
        addRadiusCircle(location)
        
    }

    func addRadiusCircle(location: CLLocation){
        self.onnscreenMap.delegate = self
        let circle = MKCircle(centerCoordinate: location.coordinate, radius: 700 as CLLocationDistance)
        self.onnscreenMap.addOverlay(circle)
    }

    func mapView(onnscreenMap: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        }
        else {
            return nil
        }
    }


    @IBAction func getLocation(sender: AnyObject) {
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        print("test1")
    }
    
    @IBAction func regionMonitoring(sender: AnyObject) {
        manager?.requestAlwaysAuthorization()
        print("test2")
//        let currentRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 1000, identifier: "Test")
//        manager?.startMonitoringForRegion(currentRegion)
        let mapRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), 3000, 3000)
        self.onnscreenMap.setRegion(mapRegion, animated: true)
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
        
            let addr = loc.thoroughfare
            
            self.address.text = addr
            
            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
            
            self.onnscreenMap.setRegion(reg, animated: true)
            
            self.onnscreenMap.showsUserLocation = true
            
        })
        
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!){
        NSLog("Your bus stop is approaching.")
        
        let entryAlert = UIAlertController(title: "Bus Stop Is Approaching", message: "Be prepared to exit the bus shortly.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okay = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        entryAlert.addAction(okay)
       
        self.presentViewController(entryAlert, animated: true, completion: nil)
      
        
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
        //var exitNotification = UIAlertController(title: "Test", message: "This is a test." , preferredStyle: .Alert);
        
        let exitAlert = UIAlertController(title: "Oh No!", message: "If you are still on the bus, you missed your stop.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okay1 = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        exitAlert.addAction(okay1)
        
        self.presentViewController(exitAlert, animated: true, completion: nil)

        
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
