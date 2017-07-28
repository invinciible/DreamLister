//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Tushar Katyal on 26/07/17.
//  Copyright © 2017 Tushar Katyal. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    // creating a time stamp for item entity whenever it will be add
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creatodon = NSDate() // assigning the time stamp
    }
}
