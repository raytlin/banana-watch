//
//  Banana.swift
//  Banana2
//
//  Created by Ray Lin on 1/18/15.
//  Copyright (c) 2015 Ray Lin. All rights reserved.
//

import Foundation
import CoreData

@objc(Banana)
class Banana: NSManagedObject {

    @NSManaged var numberBought: NSNumber
    @NSManaged var numberBrown: NSNumber?
    @NSManaged var dateBought: NSDate
    @NSManaged var dateBrown: NSDate?

}
