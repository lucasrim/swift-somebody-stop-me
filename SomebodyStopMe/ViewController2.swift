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
import AVFoundation

class ViewController2: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    var manager: CLLocationManager?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var audioPlayer = AVAudioPlayer()
    var audioUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("SomebodyStopMeBell", ofType: "aiff")!)


    
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
        let smallerRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 350, identifier: "Test Smaller Region")
        
        manager?.startMonitoringForRegion(currentRegion)
        manager?.startMonitoringForRegion(smallerRegion)
        
        // bus stop location
        
        let location = CLLocation(latitude: latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees)
        addRadiusCircle(location)
        let smallerLocation = CLLocation(latitude: latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees)
        addSmallerRadiusCircle(smallerLocation)
        
        // adds pin
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        onnscreenMap.addAnnotation(annotation)
        
        try! audioPlayer = AVAudioPlayer(contentsOfURL: audioUrl)
        
    }

    func addRadiusCircle(location: CLLocation){
        self.onnscreenMap.delegate = self
        let circle = MKCircle(centerCoordinate: location.coordinate, radius: 700 as CLLocationDistance)
        self.onnscreenMap.addOverlay(circle)
    }
    
    func addSmallerRadiusCircle(location: CLLocation){
        self.onnscreenMap.delegate = self
        let smallerCircle = MKCircle(centerCoordinate: location.coordinate, radius: 350 as CLLocationDistance)
        self.onnscreenMap.addOverlay(smallerCircle)
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
        let mapRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), 3000, 3000)
        self.onnscreenMap.setRegion(mapRegion, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // collects current locations
        
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
        if region == CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 700, identifier: "Test") {
        
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            let entryAlert = UIAlertController(title: "Bus Stop Is Approaching", message: "You'll need to get off the bus soon.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okay = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            entryAlert.addAction(okay)
            
            audioPlayer.play()
            
            self.presentViewController(entryAlert, animated: true, completion: nil)
            
            var entryNotification = UILocalNotification()
            entryNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
            entryNotification.alertBody = "Your bus stop is approaching. Be prepared to get off the bus shortly."
            entryNotification.soundName = "SomebodyStopMeBell.aiff"
            entryNotification.timeZone = NSTimeZone.defaultTimeZone()
            entryNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            
            UIApplication.sharedApplication().scheduleLocalNotification(entryNotification)
            print("test4")
            
        } else if region == CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 350, identifier: "Test Smaller Region")
            {
                NSLog("Your bus stop is RIGHT NOW.")
                
                let entryAlert = UIAlertController(title: "Bus Stop Is RIGHT NOW", message: "LEAVE.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okay = UIAlertAction(title: "GET OFF THE BUS", style: UIAlertActionStyle.Default, handler: nil)
                entryAlert.addAction(okay)
                
                self.presentViewController(entryAlert, animated: true, completion: nil)
                
                var entryNotification = UILocalNotification()
                entryNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
                entryNotification.alertBody = "GET OFF THE BUS."
                entryNotification.soundName = "TrainHorn.mp3"
                entryNotification.timeZone = NSTimeZone.defaultTimeZone()
                UIApplication.sharedApplication().scheduleLocalNotification(entryNotification)
            }
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!){
        NSLog("Have you missed your stop?")
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let exitAlert = UIAlertController(title: "Oh No!", message: "If you are still on the bus, you may have missed your stop.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okay1 = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        exitAlert.addAction(okay1)
        
        audioPlayer.play()
        
        self.presentViewController(exitAlert, animated: true, completion: nil)

        
        var exitNotification = UILocalNotification()
        exitNotification.alertBody = "Oh no, have you missed your stop?"
        exitNotification.soundName = "SomebodyStopMeBell.aiff"
        exitNotification.timeZone = NSTimeZone.defaultTimeZone()
        
        UIApplication.sharedApplication().scheduleLocalNotification(exitNotification)
        print("test5")

    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        NSLog("Something has gone terribly wrong.")
    }
}
