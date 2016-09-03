//
//  ViewController.swift
//  LocationTrackingDemoSwift
//
//  Created by common on 9/3/16.
//  Copyright © 2016 common. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentLocationViewController: UIViewController {

    // MARK: - Members
    
    // MARK: Outlets
    
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CurrentLocationViewController.locationUpdated), name: Constants.LocationUpdatedNotificationName, object: nil)
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
        let locations = realm.objects(LocationObject.self)
        if locations.count == 0 {
            return
        }
        if let lastLocation = locations.last {
            longitudeLabel.text = "Longitude: \(lastLocation.longitude)"
            latitudeLabel.text = "Latitude: \(lastLocation.latitude)"
            addressLabel.text = "Address: \(lastLocation.address)"
        }
    }
    

}

