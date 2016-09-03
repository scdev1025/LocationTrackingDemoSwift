//
//  TravelledDistanceViewController.swift
//  LocationTrackingDemoSwift
//
//  Created by common on 9/3/16.
//  Copyright © 2016 common. All rights reserved.
//

import UIKit
import RealmSwift

class TravelledDistanceViewController: UIViewController {
    
    // MARK: - Members
    
    // MARK: Outlets
    
    @IBOutlet weak var distanceLabel: UILabel!
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TravelledDistanceViewController.locationUpdated), name: Constants.LocationUpdatedNotificationName, object: nil)
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
    
    // MARK: Added
    
    func locationUpdated() {
        let realm = try! Realm()
        let totalDistance:Double = realm.objects(LocationObject.self).sum("distance")
//        var totalDistance:Double = 0
//        for location in locations {
//            totalDistance += location.distance
//        }
        distanceLabel.text = "Distance: \(Int(totalDistance))m"
    }

}
