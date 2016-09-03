//
//  LocationObject.swift
//  LocationTrackingDemoSwift
//
//  Created by common on 9/3/16.
//  Copyright © 2016 common. All rights reserved.
//

import RealmSwift

class LocationObject: Object {

    dynamic var address = ""
    dynamic var longitude:Double = 0
    dynamic var latitude:Double = 0
    dynamic var distance:Double = 0
    dynamic var recordDate:NSDate = NSDate()
}
