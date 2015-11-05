//
//  TableViewController.swift
//  SomebodyStopMe
//
//  Created by Brian Mock on 11/4/15.
//  Copyright © 2015 Lucas Rim. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
  var locations = Dictionary<String, Array<Double>>()
  
  

    override func viewDidLoad() {
        super.viewDidLoad()
//        locations["home"] = [41.631000,-87.132323]
//        locations["work"] = [35.024309,-86.204324]
//      self.locations["Work"] = [42.631000,-88.132323]
      
      if NSUserDefaults.standardUserDefaults().objectForKey("favorites") != nil {
      
        self.locations = NSUserDefaults.standardUserDefaults().objectForKey("favorites")! as! NSDictionary as! Dictionary<String, Array<Double>>
      }
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Favorite", forIndexPath: indexPath)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Favorite")
        // Configure the cell...
        cell.textLabel?.text = Array(locations.keys)[indexPath.row]
      
        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

  
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
          let key  = Array(locations.keys)[indexPath.row]
          locations.removeValueForKey(key)
          NSUserDefaults.standardUserDefaults().setObject(locations, forKey:"favorites")
          tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {    
      let row = indexPath.row
      print("55555555")
      self.performSegueWithIdentifier("favoriteToMap", sender: self)
    }
  
  
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "favoriteToMap" {
        if let destination = segue.destinationViewController as? ViewController2 {
          print(sender)
          if let locationIndex = tableView.indexPathForSelectedRow {
            print(locationIndex)
            let cell = tableView.cellForRowAtIndexPath(locationIndex)! as UITableViewCell
            print(cell.textLabel!.text)
            print(self.locations[cell.textLabel!.text!]![0] as Double)
            print(self.locations[cell.textLabel!.text!]![1] as Double)
            destination.longitude = self.locations[cell.textLabel!.text!]![1] as Double
            destination.latitude = self.locations[cell.textLabel!.text!]![0] as Double
            print("**************")
          }
        }
      }
    }
  

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
