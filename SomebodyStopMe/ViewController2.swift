//
//  ViewController2.swift
//  SomebodyStopMe
//
//  Created by Lucas Rim on 11/2/15.
//  Copyright © 2015 Lucas Rim. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class ViewController2: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    
    var textForLat : Double = 0.0
    
    var textForLon : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinatesLabel.text = "hello"
        
        latLabel.text = "\(textForLat)"
        lonLabel.text = "\(textForLon)"

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}