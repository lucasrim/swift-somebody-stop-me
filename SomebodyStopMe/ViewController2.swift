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
    var locations = Dictionary<String, Array<Double>>()
    
    var audioPlayer = AVAudioPlayer()
    var audioUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ShortBell", ofType: "aiff")!)
    var innerAudioPlayer = AVAudioPlayer()
    var innerAudioUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Alarm", ofType: "aiff")!)


    @IBAction func createFavorite(sender: UIButton) {
      let alert = UIAlertController(title: "New favorite", message: "Name this location", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
        textField.text = ""
        })
      alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
        // Setting favorite name from alert
        let favName = alert.textFields![0].text as String!
        
        // Loading NSUserDefaults locations
        if NSUserDefaults.standardUserDefaults().objectForKey("favorites") != nil {
            self.locations = NSUserDefaults.standardUserDefaults().objectForKey("favorites")! as! NSDictionary as! Dictionary<String, Array<Double>>
        }
        // Adding new favorite location to NSUserDefaults
        self.locations[favName] = [self.latitude,self.longitude]
        NSUserDefaults.standardUserDefaults().setObject(self.locations, forKey:"favorites")
        
        if favName != "" {
        
          // Loading NSUserDefaults locations
          if NSUserDefaults.standardUserDefaults().objectForKey("favorites") != nil {
            self.locations = NSUserDefaults.standardUserDefaults().objectForKey("favorites")! as! NSDictionary as! Dictionary<String, Array<Double>>
          }
          // Adding new favorite location to NSUserDefaults
          self.locations[favName] = [self.latitude,self.longitude]
          NSUserDefaults.standardUserDefaults().setObject(self.locations, forKey:"favorites")
        }
        
      }))
      self.presentViewController(alert, animated: true, completion: nil)
    }
  
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
        try! innerAudioPlayer = AVAudioPlayer(contentsOfURL: innerAudioUrl)
        
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
    }
    
    @IBAction func regionMonitoring(sender: AnyObject) {
        manager?.requestAlwaysAuthorization()
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
    
//    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!){
//        NSLog("Your bus stop is approaching.")
//        
//        audioPlayer.play()
//        
//        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//        
//        let entryAlert = UIAlertController(title: "Bus Stop Is Approaching", message: "You'll need to get off the bus soon.", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let okay = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
//        entryAlert.addAction(okay)
//        self.presentViewController(entryAlert, animated: true, completion: nil)
//        
//        var entryNotification = UILocalNotification()
//        entryNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
//        entryNotification.alertBody = "Your bus stop is approaching. Be prepared to get off the bus shortly."
//        entryNotification.soundName = "ShortBell.aiff"
//        entryNotification.timeZone = NSTimeZone.defaultTimeZone()
//        entryNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
//        
//        UIApplication.sharedApplication().scheduleLocalNotification(entryNotification)
  
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!){
        if region == CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 700, identifier: "Test") {
        
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            audioPlayer.play()
            
            let entryAlert = UIAlertController(title: "Bus Stop Is Approaching", message: "You'll need to get off the bus soon.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okay = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)

            entryAlert.addAction(okay)
            
            self.presentViewController(entryAlert, animated: true, completion: nil)
        
        
            var entryNotification = UILocalNotification()
            entryNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
            entryNotification.alertBody = "Your bus stop is approaching. Be prepared to get off the bus shortly."
            entryNotification.soundName = "ShortBell.aiff"
            entryNotification.timeZone = NSTimeZone.defaultTimeZone()
            entryNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            
            UIApplication.sharedApplication().scheduleLocalNotification(entryNotification)
       
    
        
        } else if region == CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 350, identifier: "Test Smaller Region")
            {
                NSLog("Your bus stop is here.")

                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                innerAudioPlayer.play()
                
                let entryAlert = UIAlertController(title: "Bus stop is imminent", message: "Pull!", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okay = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                entryAlert.addAction(okay)
                
                self.presentViewController(entryAlert, animated: true, completion: nil)
                
                var entryNotification = UILocalNotification()
                entryNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
                entryNotification.alertBody = "Bus stop is imminent."
                entryNotification.soundName = "Alarm.aiff"
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
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        NSLog("Something has gone terribly wrong.")
    }
}
