//
//  LocationTrackingViewController.swift
//  LocationTrackingDemoSwift
//
//  Created by common on 9/3/16.
//  Copyright © 2016 common. All rights reserved.
//

import UIKit
import RealmSwift

class LocationTrackingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Members
    
    var locations:Results<LocationObject>!
    
    
    // MARK: Outlets
    
    @IBOutlet weak var locationTableView: UITableView!
    
    // MARK: - Methods
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LocationTrackingViewController.locationUpdated), name: Constants.LocationUpdatedNotificationName, object: nil)
        locationUpdated()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: Events
    
    @IBAction func onRefresh(sender: AnyObject) {
        locationUpdated()
    }
    
    // MARK: TableView Delegate and DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locations != nil {
            return locations.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "LocationTrackingCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let location = locations[indexPath.row]
        cell.textLabel?.text = "(\(location.longitude),\(location.latitude))"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(location.recordDate)
        return cell
    }
    
    // MARK: Added
    
    func locationUpdated() {
        let realm = try! Realm()
        locations = realm.objects(LocationObject.self)
        locationTableView.reloadData()
        locationTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: locations.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }

}
