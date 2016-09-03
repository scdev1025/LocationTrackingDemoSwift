//
//  AppDelegate.swift
//  LocationTrackingDemoSwift
//
//  Created by common on 9/3/16.
//  Copyright © 2016 common. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift
import AlertBar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    var locationManager: CLLocationManager!
    
    var oldLocation:CLLocation!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setting Location Manager
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .Fitness
        locationManager.distanceFilter = 50
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        
        // Registering Notification Setting
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CurrentLocationViewController.locationUpdated), name: Constants.LocationUpdatedNotificationName, object: nil)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Location Manager Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            if oldLocation != nil {
                let distance = location.distanceFromLocation(oldLocation)
                if distance >= 50 {
                    CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks:[CLPlacemark]?, error:NSError?) in
                        if error != nil {
                            print("Reverse Geocoder Failed With Error:\(error)")
                            #if (arch(i386) || arch(x86_64))
                            
                            let realm = try! Realm()
                            try! realm.write({
                                let locationObj = realm.create(LocationObject.self)
                                locationObj.address = "test address"
                                locationObj.longitude = location.coordinate.longitude
                                locationObj.latitude = location.coordinate.latitude
                                locationObj.distance = distance
                            })
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.LocationUpdatedNotificationName, object: location)
                                
                            #endif
                        }
                        if placemarks != nil &&
                            placemarks!.count > 0 {
                            let realm = try! Realm()
                            try! realm.write({
                                let locationObj = realm.create(LocationObject.self)
                                let pm = placemarks![0] as CLPlacemark
                                locationObj.address = pm.name!
                                locationObj.longitude = location.coordinate.longitude
                                locationObj.latitude = location.coordinate.latitude
                                locationObj.distance = distance
                            })
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.LocationUpdatedNotificationName, object: location)
                        }
                    })
                }
            }else{
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks:[CLPlacemark]?, error:NSError?) in
                    if error != nil {
                        print("Reverse Geocoder Failed With Error:\(error)")
                        #if (arch(i386) || arch(x86_64))
                            
                        let realm = try! Realm()
                        try! realm.write({
                            let locationObj = realm.create(LocationObject.self)
                            locationObj.address = "test address"
                            locationObj.longitude = location.coordinate.longitude
                            locationObj.latitude = location.coordinate.latitude
                            locationObj.distance = 0
                        })
                        NSNotificationCenter.defaultCenter().postNotificationName(Constants.LocationUpdatedNotificationName, object: location)
                            
                        #endif
                    }
                    if placemarks != nil &&
                        placemarks!.count > 0 {
                        let realm = try! Realm()
                        try! realm.write({
                            let locationObj = realm.create(LocationObject.self)
                            let pm = placemarks![0] as CLPlacemark
                            locationObj.address = pm.name!
                            locationObj.longitude = location.coordinate.longitude
                            locationObj.latitude = location.coordinate.latitude
                        })
                        NSNotificationCenter.defaultCenter().postNotificationName(Constants.LocationUpdatedNotificationName, object: location)
                    }
                })
            }
            oldLocation = location
        }
    }
    
    func locationUpdated() {
        if UIApplication.sharedApplication().applicationState ==  UIApplicationState.Active {
            AlertBar.show(.Notice, message: "Location Updated")
        }else{
            let notification = UILocalNotification()
            notification.alertBody = "Location Updated"
            notification.alertAction = "open"
            notification.fireDate = NSDate()
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
}

