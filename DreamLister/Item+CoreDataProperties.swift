//
//  Item+CoreDataProperties.swift
//  DreamLister
//
//  Created by Apple on 2017/1/10.
//  Copyright © 2017年 Hans. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var title: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var price: Double
    @NSManaged public var details: String?
    @NSManaged public var toStore: Store?
    @NSManaged public var toImage: Image?
    @NSManaged public var toItemType: ItemType?

}
